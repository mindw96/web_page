import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MessageService extends ChangeNotifier {
  List<String> messageList = [];

  String api = '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';
  String endpoint = 'https://api.openai.com/v1/chat/completions';

  enterMessage(String message) {
    String userMessage = message;
    messageList.add(userMessage);
    notifyListeners();
  }

  Future<String> getRespone(String message) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $api',
    };

    Map<String, dynamic> data = {
      'model': 'gpt-3.5-turbo-0301',
      //'model': 'code-davinci-002',
      'messages': [
        {
          'role': 'system',
          'content': 'You are very kind, intelligent, and perceptive',
        },
        {
          'role': 'system',
          'content': 'you are assistant for koreans',
        },
        {'role': 'user', 'content': message},
      ],
      "temperature": 0.7,
    };

    var response = await http.post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(utf8.decode(response.bodyBytes));
      String reply =
          jsonResponse['choices'][0]['message']['content'].toString();
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
