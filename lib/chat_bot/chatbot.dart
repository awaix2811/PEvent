import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => ChatBotState();
}

class ChatBotState extends State<ChatBot> {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];

  final ChatUser currentUser = ChatUser(id: '0', firstName: "User");

  final ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage:
        "https://brandlogos.net/wp-content/uploads/2024/04/gemini-logo_brandlogos.net_fwajr-512x512.png",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Gemini Chat"),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(trailing: [
        IconButton(
          onPressed: _sendMediaMessage,
          icon: const Icon(Icons.image),
        )
      ]),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;

      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }

      gemini.streamGenerateContent(question, images: images).listen((event) {
        String response = "";

        if (event.content != null &&
            event.content!.parts != null &&
            event.content!.parts!.isNotEmpty) {
          for (var part in event.content!.parts!) {
            if (part is TextPart) {
              response += "${part.text} ";
            }
          }
        }

        setState(() {
          if (messages.isNotEmpty && messages.first.user.id == geminiUser.id) {
            final last = messages.removeAt(0);
            final updated = ChatMessage(
              user: last.user,
              createdAt: last.createdAt,
              text: last.text + response,
              medias: last.medias,
              customProperties: last.customProperties,
            );
            messages = [updated, ...messages];
          } else {
            ChatMessage reply = ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: response,
            );
            messages = [reply, ...messages];
          }
        });
      });
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }

  void _sendMediaMessage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this picture?",
        medias: [
          ChatMedia(
            url: file.path,
            fileName: file.name,
            type: MediaType.image,
          )
        ],
      );

      _sendMessage(chatMessage);
    }
  }
}
