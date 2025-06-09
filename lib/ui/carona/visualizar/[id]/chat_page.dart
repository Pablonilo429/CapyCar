import 'package:capy_car/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemUiOverlayStyle
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:routefly/routefly.dart';
// Removed unused imports: dart:io, file_picker, firebase_storage, image_picker, mime, open_filex, path_provider, http

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String roomId;
  late String caronaId;

  late Future<bool> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initData();
  }

  Future<bool> _initData() async {
    await Future.delayed(Duration.zero); // garante execução após build

    final roomArg = Routefly.query.arguments as String?;
    final caronaParam = Routefly.query['id'] as String?;

    if (roomArg == null || roomArg.isEmpty || caronaParam == null) {
      return false;
    }

    roomId = roomArg;
    caronaId = caronaParam;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == false) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text(
                'Erro: ID da carona não fornecido.',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        // --- código original após garantir que roomId e caronaId foram obtidos ---
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                IconButton(
                  iconSize: 30.0,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Routefly.navigate(
                      routePaths.carona.visualizar.$id.carona.changes({
                        'id': caronaId,
                      }),
                    );
                  },
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Chat carona",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          body: StreamBuilder<types.Room>(
            stream: FirebaseChatCore.instance.room(roomId),
            builder: (context, roomSnapshot) {
              if (!roomSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final currentRoom = roomSnapshot.data!;
              return StreamBuilder<List<types.Message>>(
                stream: FirebaseChatCore.instance.messages(currentRoom),
                builder: (context, messagesSnapshot) {
                  return Chat(

                    messages: messagesSnapshot.data ?? [],
                    onSendPressed: (partialText) =>
                        FirebaseChatCore.instance.sendMessage(
                            partialText, currentRoom.id),
                    onPreviewDataFetched: (textMessage, previewData) {
                      final updated = textMessage.copyWith(
                          previewData: previewData);
                      FirebaseChatCore.instance.updateMessage(
                          updated, currentRoom.id);
                    },
                    user: types.User(
                      id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
                    ),
                    showUserAvatars: true,
                    showUserNames: true,
                    theme: DefaultChatTheme(
                      primaryColor: Theme.of(context).primaryColor,
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
