import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CodeService extends ChangeNotifier {
  List<String> messageList = [];

  String api = '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';
  String endpoint = 'https://api.openai.com/v1/completions';
  // String endpoint = 'https://api.openai.com/v1/chat/completions';

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
      "model": "text-davinci-003",
      "temperature": 0,
      'prompt': message,
      "top_p": 1,
      "max_tokens": 256,
      "frequency_penalty": 0,
      "presence_penalty": 0,
      "stop": ["\"\"\""],
    };
    // Map<String, String> headers = {
    //   'Accept': 'application/json',
    //   'Content-Type': 'application/json',
    //   'Authorization': 'Bearer $api',
    // };
    // Map<String, dynamic> data = {
    //   "model": "gpt-3.5-turbo-0301",
    //   "temperature": 0,
    //   'messages': [
    //     {
    //       'role': 'system',
    //       'content':
    //           'You are coding assistant, so your reply must include the type of programing language',
    //     },
    //     {
    //       'role': 'user',
    //       'content': message,
    //     }
    //   ],
    //   "frequency_penalty": 0,
    //   "presence_penalty": 0,
    //   "stop": ["\"\"\""],
    // };

    var response = await http.post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(data),
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(utf8.decode(response.bodyBytes));
      String reply = jsonResponse['choices'][0]['text'].toString();
      return reply;
    } else {
      throw Exception('API request failed');
    }
    // if (response.statusCode == 200) {
    //   Map<String, dynamic> jsonResponse =
    //       jsonDecode(utf8.decode(response.bodyBytes));
    //   String reply =
    //       jsonResponse['choices'][0]['message']['content'].toString();
    //   return reply;
    // } else {
    //   throw Exception('API request failed');
    // }
  }

  clearMessageList() {
    messageList.clear();
    notifyListeners();
  }
}
