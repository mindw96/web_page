// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageService extends ChangeNotifier {
  List<String> messageList = [];
  List<String> transList = [];

  String api =
      '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';
  String endpoint = 'https://api.openai.com/v1/images/generations';
  String transEndpoint = 'https://api.openai.com/v1/chat/completions';

  Future<String> translate(String message) async {
    Map<String, String> transHeaders = {
      // 'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer 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',
    };

    Map<String, dynamic> transData = {
      'model': 'gpt-4o',
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

    var transResponse = await http.post(
      Uri.parse(transEndpoint),
      headers: transHeaders,
      body: jsonEncode(transData),
    );

    if (transResponse.statusCode == 200) {
      Map<String, dynamic> transJsonResponse =
          jsonDecode(utf8.decode(transResponse.bodyBytes));
      String transReply =
          transJsonResponse['choices'][0]['message']['content'].toString();
      return transReply;
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
