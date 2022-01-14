import 'package:chat_app/models/message_chat.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

class ChatRoom extends StatefulWidget {
  static const routeName = 'chat_room';
  const ChatRoom({Key? key, required this.userId, required this.userName})
      : super(key: key);
  final String userId;
  final String userName;

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream<QuerySnapshot>? chats;
  final _messageEditingController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  late String currentUserId;

  String? chatRoomId;

  @override
  void initState() {
    super.initState();
    getMessages();
    _focusNode.requestFocus();
  }

  void getMessages() {
    currentUserId = (Provider.of<AuthProvider>(context, listen: false)
        .getIdSharedPreferences())!;

    if (currentUserId.compareTo(widget.userId) > 0) {
      chatRoomId = '$currentUserId-${widget.userId}';
    } else {
      chatRoomId = '${widget.userId}-$currentUserId';
    }

    Provider.of<UsersProvider>(context, listen: false)
        .getMessages(chatRoomId)
        .then((val) => setState(() => chats = val));
  }

  void addMessage(messageText) {
    if (messageText.isNotEmpty) {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      Map<String, dynamic> chatMessageMap = MessageChat(
        message: messageText,
        sendBy: currentUserId,
        timestamp: timestamp,
      ).toJson();

      Provider.of<UsersProvider>(context, listen: false)
          .addMessage(chatRoomId, chatMessageMap, timestamp);
      _messageEditingController.clear();
      _scrollDown();
    }
  }

  void _scrollDown() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: kContentColorLightTheme,
            ),
            const SizedBox(width: kDefaultPadding * 0.75),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: const TextStyle(fontSize: 16),
                ),
                const Text(
                  "Active 3m ago",
                  style: TextStyle(fontSize: 12),
                )
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_phone),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {},
          ),
          const SizedBox(width: kDefaultPadding / 2),
        ],
      ),
      body: GestureDetector(
        onTap: () => _focusNode.unfocus(),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: chats,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final result = snapshot.data?.docs;
                    return ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        itemCount: result!.length,
                        itemBuilder: (context, index) {
                          return Message(
                            message: result[index]["message"],
                            sendByMe: result[index]["sendBy"] == currentUserId,
                          );
                        });
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
                vertical: kDefaultPadding / 2,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.attach_file),
                    onPressed: () {},
                    color: kPrimaryColor,
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {},
                    color: kPrimaryColor,
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.mic),
                    color: kPrimaryColor,
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              focusNode: _focusNode,
                              controller: _messageEditingController,
                              textInputAction: TextInputAction.unspecified,
                              onSubmitted: (value) {
                                addMessage(value);
                              },
                              decoration: const InputDecoration(
                                hintText: "Type message",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                                Icons.sentiment_satisfied_alt_outlined),
                            onPressed: () {},
                            color: kPrimaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Message extends StatelessWidget {
  final String message;
  final bool sendByMe;

  const Message({Key? key, required this.message, required this.sendByMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: kDefaultPadding / 2,
        left: sendByMe ? kDefaultPadding * 5 : kDefaultPadding,
        bottom: 0,
        right: sendByMe ? kDefaultPadding : kDefaultPadding * 5,
      ),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 0.75,
          vertical: kDefaultPadding / 2,
        ),
        decoration: BoxDecoration(
          borderRadius: sendByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(8))
              : const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(8)),
          color: sendByMe ? kPrimaryColor : kPrimaryColor.withOpacity(0.2),
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
              color:
                  sendByMe ? kContentColorDarkTheme : kContentColorLightTheme,
              fontSize: 16,
            )),
      ),
    );
  }
}
