// ignore_for_file: file_names, constant_identifier_names, non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../global/app_snackbar.dart';
import '../../storage/local_data.dart';

enum RequestMethod {
  GET,
  POST,
  PUT,
  PATCH,
  PUT_V2,
  MULTIPART,
  MULTIPART_PUT,
  DELETE,
}

class NetworkConfig {
  Future ApiRequestHandler(
    RequestMethod method,
    url,
    json_body, {
    is_auth = false,
    imagePath = "",
    dataPathName = "data",
    filePathName = "image",
  }) async {
    if (await InternetConnectionChecker().hasConnection) {
      var header = <String, String>{"Content-type": "application/json"};
      if (is_auth == true) {
        var localService = LocalService();
        String? token = await localService.getValue<String>(
          PreferenceKey.token,
        );
        header["Authorization"] = token!;
      }
      if (method.name == RequestMethod.GET.name) {
        try {
          var req = await http.get(Uri.parse(url), headers: header);
          log("Body : ${req.body}\n$url\n${req.statusCode}");
          //log("Status Code : ${req.statusCode}");
          if (req.statusCode == 200 || req.statusCode == 201) {
            return json.decode(req.body);
          } else if (req.statusCode == 400 || req.statusCode == 401) {
            return json.decode(req.body);
          } else {
            return null;
          }
        } catch (e) {
          ShowError(e);
        }
      } else if (method.name == RequestMethod.POST.name) {
        try {
          var req = await http.post(
            Uri.parse(url),
            headers: header,
            body: json_body,
          );

          log("RESPONSE STATUS CODE : ${req.statusCode}");
          log("RESPONSE  BODY : ${req.body}");
          log("RESPONSE  HEADER : ${req.headers}");
          log("RESPONSE  URL : ${Uri.parse(url)}");

          if (req.statusCode == 200 || req.statusCode == 201) {
            return json.decode(req.body);
          } else if (req.statusCode == 400 ||
              req.statusCode == 401 ||
              req.statusCode == 403 ||
              req.statusCode == 404 ||
              req.statusCode == 409 ||
              req.statusCode == 422) {
            return json.decode(req.body);
          } else if (req.statusCode == 300 || req.statusCode == 308) {
            return json.decode(req.body);
          } else if (req.statusCode == 500) {
            final data = json.decode(req.body); // decode to Map
            var errorMsg = data['message'] ?? 'Server Error';
            ShowError(errorMsg);
          } else {
            final data = json.decode(req.body); // decode to Map
            var errorMsg = data['message'] ?? 'Try again after some time';
            ShowError(errorMsg);
            // throw Exception('Try aging after some time');
          }
        } catch (e) {
          ShowError(e);
        }
      } else if (method.name == RequestMethod.PATCH.name) {
        try {
          var req = await http.patch(
            Uri.parse(url),
            headers: header,
            body: json_body,
          );
          print(req.statusCode);
          if (req.statusCode == 200 || req.statusCode == 201) {
            return json.decode(req.body);
          } else {
            final data = json.decode(req.body); // decode to Map
            var errorMsg = data['message'] ?? 'Server Error';
            ShowError(errorMsg);
          }
        } catch (e) {
          ShowError(e);
        }
      } else if (method.name == RequestMethod.PUT.name) {
        try {
          var req = await http.put(
            Uri.parse(url),
            headers: header,
            body: json_body,
          );
          print(req.statusCode);
          if (req.statusCode == 200 || req.statusCode == 201) {
            return json.decode(req.body);
          } else {
            final data = json.decode(req.body); // decode to Map
            var errorMsg = data['message'] ?? 'Server Error';
            ShowError(errorMsg);
          }
        } catch (e) {
          ShowError(e);
        }
      } else if (method.name == RequestMethod.MULTIPART.name) {
        String? token;
        if (is_auth == true) {
          var localService = LocalService();
          token = await localService.getValue<String>(PreferenceKey.token);
        }

        try {
          var request = http.MultipartRequest(
            'POST',
            Uri.parse(url), // Adjust URL as needed
          );
          request.headers.addAll({
            'Accept': 'application/json',
            if (token != null) 'Authorization': token,
          });

          print("MULTIPART request URL: $url");
          print("MULTIPART dataPathName: $dataPathName");
          print("MULTIPART filePathName: $filePathName");
          print("MULTIPART json_body: $json_body");
          print("MULTIPART imagePath: $imagePath");

          request.fields['$dataPathName'] = json_body;
          if (imagePath.isNotEmpty) {
            File imageFile = File(imagePath);
            if (await imageFile.exists()) {
              request.files.add(
                await http.MultipartFile.fromPath(
                  '$filePathName',
                  imagePath,
                  filename: 'img_${DateTime.now().millisecondsSinceEpoch}.jpg',
                ),
              );
              log("Image file added to request: $imagePath");
            }
          }

          final streamedResponse = await request.send();
          final response = await http.Response.fromStream(streamedResponse);
          print("MULTIPART response status: ${response.statusCode}");
          print("MULTIPART response body: ${response.body}");

          if (response.statusCode == 200 || response.statusCode == 201) {
            return json.decode(response.body);
          } else {
            try {
              final data = json.decode(response.body);
              var errorMsg = data['message'] ?? 'Server Error';
              print("MULTIPART error: $errorMsg");
              ShowError(errorMsg);
            } catch (e) {
              print("MULTIPART error parsing response: $e");
              ShowError("Server Error");
            }
            return null;
          }
        } catch (e) {
          print("MULTIPART exception: $e");
          ShowError(e);
          return null;
        }
      } else if (method.name == RequestMethod.MULTIPART_PUT.name) {
        String? token;
        if (is_auth == true) {
          var localService = LocalService();
          token = await localService.getValue<String>(PreferenceKey.token);
        }

        try {
          var request = http.MultipartRequest(
            'PUT', //  IMPORTANT
            Uri.parse(url),
          );

          request.headers.addAll({
            'Accept': 'application/json',
            if (token != null) 'Authorization': token,
            // If your backend expects Bearer:
            // 'Authorization': 'Bearer $token',
          });

          print("MULTIPART PUT URL: $url");
          print("MULTIPART PUT dataPathName: $dataPathName");
          print("MULTIPART PUT filePathName: $filePathName");
          print("MULTIPART PUT json_body: $json_body");
          print("MULTIPART PUT imagePath: $imagePath");

          // JSON body as field
          request.fields[dataPathName] = json_body;

          // File upload
          if (imagePath.isNotEmpty) {
            File imageFile = File(imagePath);
            if (await imageFile.exists()) {
              request.files.add(
                await http.MultipartFile.fromPath(
                  filePathName,
                  imagePath,
                  filename: 'img_${DateTime.now().millisecondsSinceEpoch}.jpg',
                ),
              );
              log("Image file added to PUT request: $imagePath");
            }
          }

          final streamedResponse = await request.send();
          final response = await http.Response.fromStream(streamedResponse);

          print("MULTIPART PUT status: ${response.statusCode}");
          print("MULTIPART PUT body: ${response.body}");

          if (response.statusCode == 200 || response.statusCode == 201) {
            return json.decode(response.body);
          } else if (response.statusCode == 400 || response.statusCode == 401) {
            return json.decode(response.body);
          } else {
            try {
              final data = json.decode(response.body);
              ShowError(data['message'] ?? 'Server Error');
            } catch (e) {
              ShowError("Server Error");
            }
            return null;
          }
        } catch (e) {
          print("MULTIPART PUT exception: $e");
          ShowError(e.toString());
          return null;
        }
      } else if (method.name == RequestMethod.PUT_V2.name) {
        try {
          var request = http.MultipartRequest("PUT", Uri.parse(url));
          request.headers.addAll(header);

          if (json_body != null) {
            request.fields["data"] = json_body;
          }
          var streamedResponse = await request.send();
          var response = await http.Response.fromStream(streamedResponse);
          print("PUT response: ${response.statusCode}");
          print(response.body);
          if (response.statusCode == 200 || response.statusCode == 201) {
            return json.decode(response.body);
          } else {
            final data = json.decode(response.body); // decode to Map
            var errorMsg = data['message'] ?? 'Server Error';
            ShowError(errorMsg);
          }
        } catch (e) {
          ShowError(e);
        }
      } else if (method.name == RequestMethod.DELETE.name) {
        try {
          var req = await http.delete(Uri.parse(url), headers: header);

          print(req.statusCode);
          print(req);
          if (req.statusCode == 200 || req.statusCode == 201) {
            return json.decode(req.body);
          } else if (req.statusCode == 400 || req.statusCode == 401) {
            return json.decode(req.body);
          } else if (req.statusCode == 500) {
            // Handle 500 error - still return response for better error handling
            try {
              final data = json.decode(req.body);
              var errorMsg = data['message'] ?? 'Server Error';
              ShowError(errorMsg);
              return data; // Return the response even on error
            } catch (e) {
              ShowError('Server Error');
              return null;
            }
          } else {
            try {
              final data = json.decode(req.body);
              var errorMsg = data['message'] ?? 'Server Error';
              ShowError(errorMsg);
              return data;
            } catch (e) {
              ShowError('Try again after some time');
              return null;
            }
          }
        } catch (e) {
          ShowError(e);
          return null;
        }
      }
    } else {
      Fluttertoast.showToast(msg: "Please Connect Internet");
    }
  }

  void ShowError(dynamic msg) {
    AppSnackBar.show(message: msg.toString(), isSuccess: false);
  }
}
