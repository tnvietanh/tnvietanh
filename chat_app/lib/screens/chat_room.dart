import 'package:chat_app/components/user_avatar.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

class ChatRoom extends StatefulWidget {
  static const routeName = 'chat_room';
  const ChatRoom(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.currentId})
      : super(key: key);
  final String userId;
  final String userName;
  final String currentId;

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final _messageEditingController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  void addMessage(messageText) {
    if (messageText.isNotEmpty) {
      Provider.of<UsersProvider>(context, listen: false)
          .addMessage(widget.userId, widget.userName, messageText);
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
            ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(20), // Image radius
                child: UserAvatar(
                    stream: Provider.of<UsersProvider>(context, listen: false)
                        .getUserAvatar(widget.userId)),
              ),
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
              child: StreamBuilder<QuerySnapshot>(
                stream: Provider.of<UsersProvider>(context, listen: false)
                    .getMessages(widget.userId),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final result = snapshot.data?.docs;
                    return ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        itemCount: result!.length,
                        itemBuilder: (context, index) {
                          return Message(
                            userId: widget.userId,
                            message: result[index]["message"],
                            sendByMe:
                                result[index]["idFrom"] == widget.currentId,
                          );
                        });
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding / 2,
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
  final String userId;

  const Message({
    Key? key,
    required this.message,
    required this.sendByMe,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: kDefaultPadding / 2,
        left: sendByMe ? kDefaultPadding * 5 : kDefaultPadding / 2,
        right: sendByMe ? kDefaultPadding / 2 : kDefaultPadding * 5,
      ),
      child: Row(
        mainAxisAlignment:
            sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!sendByMe)
            ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(12), // Image radius
                child: UserAvatar(
                  stream: Provider.of<UsersProvider>(context, listen: false)
                      .getUserAvatar(userId),
                ),
              ),
            ),
          const SizedBox(width: kDefaultPadding / 2),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding * 0.75,
              vertical: kDefaultPadding / 2,
            ),
            decoration: BoxDecoration(
              borderRadius: sendByMe
                  ? BorderRadius.circular(28)
                  : const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                      bottomLeft: Radius.circular(8)),
              color: sendByMe ? kPrimaryColor : kPrimaryColor.withOpacity(0.2),
            ),
            child: Text(message,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: sendByMe
                      ? kContentColorDarkTheme
                      : kContentColorLightTheme,
                  fontSize: 16,
                )),
          ),
        ],
      ),
    );
  }
}
