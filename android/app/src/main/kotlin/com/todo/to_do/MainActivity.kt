package com.todo.to_do

import android.app.AppOpsManager
import android.app.usage.UsageStats
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.os.Build
import android.os.Process
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.util.*

class MainActivity : FlutterActivity() {
    private val channelName = "com.todo.to_do/usage_stats"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkUsagePermission" -> {
                    result.success(hasUsageStatsPermission())
                }
                "grantUsagePermission" -> {
                    try {
                        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("SETTING_NOT_FOUND", "Could not open usage settings", null)
                    }
                }
                "getUsageStats" -> {
                    val startTime = call.argument<Long>("startTime") ?: 0L
                    val endTime = call.argument<Long>("endTime") ?: System.currentTimeMillis()
                    result.success(getUsageStatistics(startTime, endTime))
                }
                "getAppIcon" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        result.success(getAppIcon(packageName))
                    } else {
                        result.error("INVALID_PACKAGE", "Package name is null", null)
                    }
                }
                "getAppLabel" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        result.success(getAppLabel(packageName))
                    } else {
                        result.error("INVALID_PACKAGE", "Package name is null", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun hasUsageStatsPermission(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, Process.myUid(), packageName)
        } else {
            @Suppress("DEPRECATION")
            appOps.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, Process.myUid(), packageName)
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun getUsageStatistics(startTime: Long, endTime: Long): List<Map<String, Any>> {
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val stats = usageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, startTime, endTime)
        
        val result = mutableListOf<Map<String, Any>>()
        if (stats != null) {
            val aggregatedStats = mutableMapOf<String, UsageStats>()
            for (usageStats in stats) {
                val pkg = usageStats.packageName
                val existing = aggregatedStats[pkg]
                if (existing == null || usageStats.totalTimeInForeground > existing.totalTimeInForeground) {
                     aggregatedStats[pkg] = usageStats
                }
            }

            for (usageStats in aggregatedStats.values) {
                if (usageStats.totalTimeInForeground > 0) {
                    val map = mutableMapOf<String, Any>()
                    map["packageName"] = usageStats.packageName
                    map["totalTimeInForeground"] = usageStats.totalTimeInForeground
                    map["lastTimeUsed"] = usageStats.lastTimeUsed
                    result.add(map)
                }
            }
        }
        return result
    }

    private fun getAppIcon(packageName: String): ByteArray? {
        return try {
            val pm = packageManager
            val icon = pm.getApplicationIcon(packageName)
            val bitmap = drawableToBitmap(icon)
            val stream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
            stream.toByteArray()
        } catch (e: Exception) {
            null
        }
    }

    private fun getAppLabel(packageName: String): String {
        return try {
            val pm = packageManager
            val info = pm.getApplicationInfo(packageName, 0)
            pm.getApplicationLabel(info).toString()
        } catch (e: Exception) {
            packageName
        }
    }

    private fun drawableToBitmap(drawable: Drawable): Bitmap {
        if (drawable is BitmapDrawable) {
            return drawable.bitmap
        }
        val width = if (drawable.intrinsicWidth > 0) drawable.intrinsicWidth else 100
        val height = if (drawable.intrinsicHeight > 0) drawable.intrinsicHeight else 100
        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, canvas.width, canvas.height)
        drawable.draw(canvas)
        return bitmap
    }
}
