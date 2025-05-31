import 'package:capy_car/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemUiOverlayStyle
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:routefly/routefly.dart';
// Removed unused imports: dart:io, file_picker, firebase_storage, image_picker, mime, open_filex, path_provider, http

class ChatPage extends StatefulWidget {
  // Changed from caronaId for clarity, represents the room ID

  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // No need for _isAttachmentUploading state

  late final String roomId;
  late final String caronaId;

  @override
  void initState() {
    super.initState();
    roomId = (Routefly.query.arguments as String?)!;
    caronaId =  (Routefly.query['id'] as String?)!;

    if (roomId?.isEmpty ?? true) {
      debugPrint("ID da carona não encontrado na rota.");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Erro: ID da carona não fornecido."),
              backgroundColor: Colors.red,
            ),
          );
          Routefly.navigate(routePaths.carona.caronaHome);
        }
      });
    }
  }

  // Handles sending text messages
  void _handleSendPressed(types.PartialText message, String currentRoomId) {
    FirebaseChatCore.instance.sendMessage(message, currentRoomId);
  }

  // Handles fetching preview data for URLs in text messages
  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
    String currentRoomId,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);
    FirebaseChatCore.instance.updateMessage(updatedMessage, currentRoomId);
  }

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: Text(
                "Chat carona",
                style: const TextStyle(
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
        initialData: null, // No initial room data, fetched by ID
        stream: FirebaseChatCore.instance.room(roomId),
        builder: (context, roomSnapshot) {
          if (roomSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!roomSnapshot.hasData || roomSnapshot.data == null) {
            // You might want to handle the case where the room doesn't exist
            // or an error occurred more gracefully.
            return const Center(
              child: Text('Room not found or error loading room.'),
            );
          }

          final currentRoom = roomSnapshot.data!;

          return StreamBuilder<List<types.Message>>(
            initialData: const [],
            stream: FirebaseChatCore.instance.messages(currentRoom),
            builder: (context, messagesSnapshot) {
              if (messagesSnapshot.connectionState == ConnectionState.waiting &&
                  messagesSnapshot.data!.isEmpty) {
                // Show loading indicator only if there are no messages yet
                return const Center(child: CircularProgressIndicator());
              }
              // If there's an error, messagesSnapshot.hasError will be true.
              // If messagesSnapshot.data is null, it means no messages or still loading initial.
              // Default to empty list if null.

              return Chat(
                messages: messagesSnapshot.data ?? [],
                onAttachmentPressed: null,
                // Disabled: No attachment button
                // onMessageTap: null, // No custom tap handling for text-only messages
                // Default tap behavior (like copy) will still work.
                onPreviewDataFetched:
                    (textMessage, previewData) => _handlePreviewDataFetched(
                      textMessage,
                      previewData,
                      currentRoom.id,
                    ),
                onSendPressed:
                    (partialText) =>
                        _handleSendPressed(partialText, currentRoom.id),
                user: types.User(
                  id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
                ),
                showUserAvatars: true,
                showUserNames: true,
                theme: DefaultChatTheme(
                  primaryColor: Theme.of(context).primaryColor
                ),
                // Options for text-only chat:
                // You can customize theme, date headers, etc.
                // Example:
                // theme: const DefaultChatTheme(
                //   inputBackgroundColor: Colors.blueAccent,
                //   primaryColor: Colors.blue,
                // ),
                // dateFormat: DateFormat('MMM d, yyyy'), // If you want to customize date format
                // timeFormat: DateFormat('HH:mm'), // If you want to customize time format
              );
            },
          );
        },
      ),
    );
  }
}
