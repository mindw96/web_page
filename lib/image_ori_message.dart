// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mimir/env.dart';

class ImageServiceOri extends ChangeNotifier {
  final FirebaseDatabase _realtime = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://mimir-1a487-default-rtdb.firebaseio.com/');
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  List<String> messageList = [];

  String api = Env.openAiApiKey;
  String endpoint = 'https://api.openai.com/v1/images/generations';

  enterMessage(String message, int indexingNum) async {
    await _realtime
        .ref('users')
        .child(uid!)
        .child('dall-e-3')
        .child('$indexingNum')
        .update({'role': 'user', 'content': message});
    notifyListeners();
  }

  Future<void> getResponseFromOpenAI(String userInput, int indexingNum) async {
    DataSnapshot snapshot =
        await _realtime.ref("users").child(uid!).child('dall-e-3').get();
    List<dynamic> value = snapshot.value as List<dynamic>;
    int cnt = value.length;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $api',
    };

    List messages = [];

    if (cnt >= 2) {
      for (var item in value) {
        if (item == null) {
          continue;
        } else if (item is List) {
          messages.add(item[0]);
        } else if (item is Map) {
          messages.add(item);
        }
      }
    } else {
      messages.add({
        'prompt': userInput,
        'model': 'dall-e-3',
        "n": 1,
        // "size": "256x256"
        // "size": "512x512"
        "size": "1024x1024",
        "style": "natural",
        "quality": "hd",
      });
    }

    Map<String, dynamic> data = {
      'prompt': userInput,
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

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(utf8.decode(response.bodyBytes));

      String reply = jsonResponse['data'][0]['url'].toString();
      print(reply);
      await _realtime
          .ref('users')
          .child(uid!)
          .child('dall-e-3')
          .child('$indexingNum')
          .update({'role': 'assistant', 'content': reply});
    } else {
      await _realtime
          .ref('users')
          .child(uid!)
          .child('dall-e-3')
          .child('$indexingNum')
          .update({'role': 'assistant', 'content': '${response.statusCode}'});
    }
  }

  clearMessageList() {
    _realtime.ref("users").child(uid!).child('dall-e-3').remove();
    notifyListeners();
  }
}
