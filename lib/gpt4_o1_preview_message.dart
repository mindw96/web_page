import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GPT4o1PreviewMessageService extends ChangeNotifier {
  List<String> messageList = [];

  String api =
      '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';
  String endpoint = 'https://api.openai.com/v1/chat/completions';

  enterMessage(String message) {
    String userMessage = message;
    messageList.add(userMessage);
    notifyListeners();
  }

  Future<String> getRespone(String message) async {
    Map<String, String> headers = {
      // 'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $api',
    };

    Map<String, dynamic> data = {
      'model': 'o1-preview',
      // "temperature": 0.7,
    };
    List messages = [
      {
        'role': 'system',
        'content': 'You are very kind, intelligent, and perceptive',
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
    // ignore: avoid_print
    print(response.statusCode);
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
}
