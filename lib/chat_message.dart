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
      // 'messages': [
      //   {
      //     'role': 'system',
      //     'content': 'You are very kind, intelligent, and perceptive',
      //   },
      //   {
      //     'role': 'system',
      //     'content':
      //         'you are assistant for koreans, so you have to replay only korean',
      //   },
      // ],
      "temperature": 0.7,
    };
    List messages = [
      {
        'role': 'system',
        'content': 'You are very kind, intelligent, and perceptive',
      },
      {
        'role': 'system',
        'content':
            'you are assistant for koreans, so you have to reply only korean',
      },
    ];
    if (messageList.length >= 3) {
      for (int i = 0; i < messageList.length; i++) {
        if ((i + 1) % 2 != 0) {
          messages.add({'role': 'user', 'content': messageList[i]});
        } else {
          messages.add({'role': 'assistant', 'content': messageList[i]});
        }
      }
      messages.add({'role': 'user', 'content': message});
    } else {
      messages.add({'role': 'user', 'content': message});
    }
    data['messages'] = messages;
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
