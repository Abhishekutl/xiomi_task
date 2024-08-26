import 'dart:developer';
import 'package:demo/Services/networkService.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import "package:path/path.dart" as path;
import 'dart:io';
import 'dart:convert';
import 'dart:async';


class ApiProvider implements NetworkBaseClass {
  Map<String, String> header = {
    'Content-Type': 'application/json',
  };

  var baseUrl = "";


  @override
  Future<dynamic> uploadFormImageApi(
      String url, String imageUrl, Map<String, dynamic> body) async {
    var uri = Uri.parse(baseUrl + url);
    var responseJson;

    try {
      log('url : $uri');
      log('header : $header');
      log('body : $body');

      var networkImageResponse = await http.get(Uri.parse(imageUrl));
      if (networkImageResponse.statusCode != 200) {
        throw Exception("Failed to download image from network");
      }

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File file = File(path.join(tempPath, path.basename(imageUrl)));
      await file.writeAsBytes(networkImageResponse.bodyBytes);

      final request = http.MultipartRequest('POST', uri);
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile('user_image', stream, length,
          filename: path.basename(file.path));
      request.files.add(multipartFile);

      header.forEach((key, value) {
        request.headers[key] = value;
      });

      body.forEach((key, value) {
        request.fields[key] = value;
      });

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);
      responseJson = _response(responseBody);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  @override
  Future<dynamic> fromApi(String url, Map<String, dynamic> body) async {
    var uri = Uri.parse(baseUrl + url);
    var responseJson;
    try {
      log('url : $uri');
      log('header : $header');
      log('body : $body');
      final request = http.MultipartRequest('POST', uri);

      header.forEach((key, value) {
        request.headers[key] = value;
      });

      // body
      body.forEach((key, value) {
        request.fields[key] = value;
      });
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);
      responseJson = _response(responseBody);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print('response: $responseJson');
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}
