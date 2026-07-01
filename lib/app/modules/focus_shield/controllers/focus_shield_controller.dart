import 'package:get/get.dart';

import '../../../../core/service/app_blocker/focus_shield_service.dart';

class FocusShieldController extends GetxController {
  final _service = FocusShieldService.to;

  bool get isShieldEnabled => _service.isEnabled.value;
  List<String> get blockedPackages => _service.blockedPackageNames;
  bool get hasPermission => _service.isPermissionGranted.value;

  Future<void> toggleShield(bool value) async {
    await _service.toggleShield(value);
  }

  Future<void> requestPermission() async {
    await _service.requestPermissions();
  }

  Future<void> updateBlockedApps(List<String> packages) async {
    await _service.updateBlockedApps(packages);
  }
}
