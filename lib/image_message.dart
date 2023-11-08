import 'dart:convert';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageService extends ChangeNotifier {
  List<String> messageList = [];
  List<String> transList = [];

  String api = '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';
  String endpoint = 'https://api.openai.com/v1/images/generations';
  String trans_endpoint = 'https://api.openai.com/v1/chat/completions';

  Future<String> translate(String message) async {
    Map<String, String> trans_headers = {
      // 'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer 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',
    };

    Map<String, dynamic> trans_data = {
      'model': 'gpt-3.5-turbo-1106',
      "temperature": 0,
      "messages": [
        {
          'role': 'system',
          'content': 'You are a translator who converts Korean to English.',
        },
        {
          'role': 'system',
          'content': 'You have to reply only transrate result.',
        },
        {
          'role': 'user',
          'content': "translate this sentences to english '$message'"
        },
      ]
    };

    var trans_response = await http.post(
      Uri.parse(trans_endpoint),
      headers: trans_headers,
      body: jsonEncode(trans_data),
    );

    if (trans_response.statusCode == 200) {
      Map<String, dynamic> trans_jsonResponse =
          jsonDecode(utf8.decode(trans_response.bodyBytes));
      String trans_reply =
          trans_jsonResponse['choices'][0]['message']['content'].toString();
      return trans_reply;
    } else {
      throw Exception('API request failed');
    }
  }

  enterMessage(String message) {
    String userMessage = message;
    messageList.add(userMessage);
    notifyListeners();
  }

  enterTrans(String message) {
    String transMessage = message;
    transList.add(transMessage);
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
      "size": "1024x1024"
    };

    var response = await http.post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(data),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(utf8.decode(response.bodyBytes));
      print(jsonResponse);
      String reply = jsonResponse['data'][0]['url'].toString();
      print(reply);
      return reply;
    } else {
      print('fail');
      throw Exception('API request failed');
    }
  }

  clearMessageList() {
    messageList.clear();
    notifyListeners();
  }

  clearTransList() {
    transList.clear();
    notifyListeners();
  }

  deleteLast() {
    messageList.removeLast();
    notifyListeners();
  }
}
