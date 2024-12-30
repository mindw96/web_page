import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mimir/env.dart';

class GPT4MiniMessageService extends ChangeNotifier {
  final FirebaseDatabase _realtime = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://mimir-1a487-default-rtdb.firebaseio.com/');
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  String api = Env.openAiApiKey;
  String endpoint = 'https://api.openai.com/v1/chat/completions';

  enterMessage(String message, int indexingNum) async {
    await _realtime
        .ref('users')
        .child(uid!)
        .child('gpt-4o-mini')
        .child('$indexingNum')
        .update({'role': 'user', 'content': message});

    notifyListeners();
  }

  Future<void> getResponseFromOpenAI(String userInput, int indexingNum) async {
    DataSnapshot snapshot =
        await _realtime.ref("users").child(uid!).child('gpt-4o-mini').get();
    List<dynamic> value = snapshot.value as List<dynamic>;

    int cnt = value.length;
    List messages = [
      {
        'role': 'system',
        'content': 'You are very kind, intelligent, and perceptive',
      },
    ];

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
      messages.add({'role': 'user', 'content': userInput});
    }
    final request = http.Request('POST', Uri.parse(endpoint))
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $api',
      })
      ..body = jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': messages,
        'stream': true, // 스트림 활성화
      });

    final streamedResponse = await http.Client().send(request);

    if (streamedResponse.statusCode == 200) {
      final stream = streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      String responseText = '';
      await for (final line in stream) {
        if (line.trim().isEmpty || !line.startsWith('data:')) continue;
        final content = line.substring(5).trim(); // 'data:' 이후의 JSON 추출
        if (content == '[DONE]') break;

        try {
          final jsonData = jsonDecode(content);
          final token = jsonData['choices'][0]['delta']['content'] ?? '';
          if (token.isNotEmpty) {
            responseText += token;

            // 중간 결과를 실시간으로 Firebase에 저장
            await _realtime
                .ref('users')
                .child(uid!)
                .child('gpt-4o-mini')
                .child('$indexingNum')
                .update({'role': 'assistant', 'content': responseText});
          }
        } catch (e) {
          debugPrint('Error parsing JSON: $e');
        }
      }
    } else {
      debugPrint(
          'Failed to connect to OpenAI API: ${streamedResponse.reasonPhrase}');
    }
  }

  clearMessageList() {
    _realtime.ref("users").child(uid!).child('gpt-4o-mini').remove();
  }
}
