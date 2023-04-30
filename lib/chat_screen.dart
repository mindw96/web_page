import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> messages = [];
  TextEditingController textController = TextEditingController();

  Future<String> sendMessage(String message) async {
    String api = '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';
    String endpoint = 'https://api.openai.com/v1/chat/completions';

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $api',
    };

    Map<String, dynamic> data = {
      'model': 'gpt-3.5-turbo-0301',
      'messages': [
        {
          'role': 'system',
          'content':
              'You are very kind, intelligent, and perceptive and you have to start new line',
        },
        {'role': 'user', 'content': message},
      ],
      "temperature": 0.5,
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

  void _sendMessage() async {
    String userMessage = textController.text.trim();
    if (userMessage.isNotEmpty) {
      setState(() {
        messages.add('$userMessage');
        textController.clear();
      });

      try {
        String response = await sendMessage(userMessage);
        setState(() {
          messages.add('$response');
        });
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 216, 216, 223),
        elevation: 0.1,
        title: Center(
          child: Column(
            children: [
              Icon(
                CupertinoIcons.smiley,
                size: 30,
                color: Colors.black,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "iGPT",
                style: TextStyle(color: Colors.black, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: (index + 1) % 2 == 0
                      ? Column(
                          // Bot Message
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       top: 10, bottom: 0, left: 10, right: 10),
                            //   child: Text(
                            //     'Bot',
                            //     textAlign: TextAlign.start,
                            //   ),
                            // ),
                            Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 180, 180, 188),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Flexible(
                                  child: Text(
                                    messages[index],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          // User Message
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       top: 10, bottom: 0, left: 10, right: 10),
                            //   child: Text(
                            //     'You',
                            //     textAlign: TextAlign.end,
                            //   ),
                            // ),
                            Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 34, 148, 251),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  messages[index],
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoTextField(
                    controller: textController,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(38),
                    ),
                    padding: EdgeInsets.only(left: 30, right: 30),
                    suffix: CupertinoButton(
                      child: Icon(
                        CupertinoIcons.arrow_up_circle_fill,
                        size: 40,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
