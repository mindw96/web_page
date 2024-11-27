import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageServiceOri extends ChangeNotifier {
  List<String> messageList = [];

  String api =
      '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';
  String endpoint = 'https://api.openai.com/v1/images/generations';

  enterMessage(String message) {
    String userMessage = message;
    messageList.add(userMessage);
    notifyListeners();
  }

  Future<String> getRespone(String message) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $api',
    };

    Map<String, dynamic> data = {
      'prompt': message,
      'model': 'dall-e-3',
      "n": 1,
      // "size": "256x256"
      // "size": "512x512"
      "size": "1024x1024",
      "style": "natural",
      "quality": "hd",
    };

    var response = await http.post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(data),
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(utf8.decode(response.bodyBytes));

      String reply = jsonResponse['data'][0]['url'].toString();
      print(reply);
      return reply;
    } else {
      throw Exception('API request failed');
    }
  }

  clearMessageList() {
    messageList.clear();
    notifyListeners();
  }

  deleteLast() {
    messageList.removeLast();
    notifyListeners();
  }
}
