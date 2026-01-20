import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class CloudinaryService {
  static const String cloudName = "debwe3pei";
  static const String uploadPreset = "profilePicture";

  static Future<String?> uploadImage(File imageFile) async {
    try {
      if (cloudName == "YOUR_CLOUD_NAME" ||
          uploadPreset == "YOUR_UPLOAD_PRESET") {
        debugPrint("Cloudinary credentials not configured.");
        return null;
      }

      final url =
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);

      if (response.statusCode == 200) {
        final secureUrl = jsonMap['secure_url'];
        debugPrint("Cloudinary Upload Success: $secureUrl");
        return secureUrl;
      } else {
        debugPrint(
            "Cloudinary Upload Failed: ${response.statusCode} - ${jsonMap['error']['message']}");
        return null;
      }
    } catch (e) {
      debugPrint("Cloudinary Upload Error: $e");
      return null;
    }
  }
}
