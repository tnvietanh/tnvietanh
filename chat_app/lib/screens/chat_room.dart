import 'dart:io';

import 'package:chat_app/components/user_avatar.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/screens/photo_view.dart';
import 'package:chat_app/screens/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

enum MessageType { text, image }

class ChatRoom extends StatefulWidget {
  static const routeName = 'chat_room';
  const ChatRoom(
      {Key? key,
      required this.document,
      required this.currentId,
      required this.userProvider})
      : super(key: key);

  final DocumentSnapshot document;
  final String currentId;
  final UserProvider userProvider;

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final _messageEditingController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  late UserModel userModel;
  late String chatRoomId;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    userModel = UserModel.fromDocument(widget.document);
    if (widget.currentId.compareTo(userModel.id) > 0) {
      chatRoomId = '${widget.currentId}-${userModel.id}';
    } else {
      chatRoomId = '${userModel.id}-${widget.currentId}';
    }
  }

  void addMessage(messageText) {
    if (messageText.isNotEmpty) {
      Provider.of<UserProvider>(context, listen: false).addMessage(
          chatRoomId, userModel.id, messageText, MessageType.text.name);
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

  void _imagePicker(ImageSource key) async {
    final pickerFile =
        await ImagePicker().pickImage(source: key, imageQuality: 25);
    if (pickerFile != null) {
      uploadFile(File(pickerFile.path));
    }
  }

  void uploadFile(File file) async {
    UploadTask uploadTask =
        Provider.of<UserProvider>(context, listen: false).uploadFile(
      file,
      chatRoomId,
      DateTime.now().millisecondsSinceEpoch.toString(),
    );
    TaskSnapshot snapshot = await uploadTask;
    final photoURL = await snapshot.ref.getDownloadURL();
    Provider.of<UserProvider>(context, listen: false)
        .addMessage(chatRoomId, userModel.id, photoURL, MessageType.image.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfile(
                          chatRoomId: chatRoomId,
                          userDocument: widget.document,
                          userProvider: widget.userProvider,
                        )));
          },
          child: Row(
            children: [
              UserAvatar(
                  size: 20,
                  stream: Provider.of<UserProvider>(context, listen: false)
                      .getUser('id', userModel.id)),
              const SizedBox(width: kDefaultPadding * 0.75),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 142,
                    child: Text(
                      userModel.userName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding / 4),
                  userModel.isOnline
                      ? const Text('Đang hoạt động',
                          style: TextStyle(fontSize: 12))
                      : const Text('Offline', style: TextStyle(fontSize: 12))
                ],
              )
            ],
          ),
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
                stream: Provider.of<UserProvider>(context, listen: false)
                    .getMessages(userModel.id),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    final result = snapshot.data?.docs;
                    return ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      itemCount: result!.length,
                      itemBuilder: (context, index) {
                        return Message(
                          userId: userModel.id,
                          message: result[index]["message"],
                          type: result[index]['type'],
                          sendByMe: result[index]["idFrom"] == widget.currentId,
                        );
                      },
                    );
                  } else {
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
                    icon: const Icon(Icons.image),
                    onPressed: () {
                      _imagePicker(ImageSource.gallery);
                    },
                    color: kPrimaryColor,
                  ),
                  const SizedBox(width: kDefaultPadding / 2),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {
                      _imagePicker(ImageSource.camera);
                    },
                    color: kPrimaryColor,
                  ),
                  const SizedBox(width: kDefaultPadding / 2),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.mic),
                    color: kPrimaryColor,
                    onPressed: () {},
                  ),
                  const SizedBox(width: kDefaultPadding / 2),
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
                              textInputAction: TextInputAction.unspecified,
                              controller: _messageEditingController,
                              onSubmitted: (value) {
                                addMessage(value);
                              },
                              decoration: InputDecoration(
                                hintText: 'Aa',
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.send),
                                  onPressed: () {},
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
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
  final String type;
  final bool sendByMe;
  final String userId;

  const Message({
    Key? key,
    required this.message,
    required this.type,
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
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!sendByMe)
            UserAvatar(
              size: 12,
              stream: Provider.of<UserProvider>(context, listen: false)
                  .getUser('id', userId),
            ),
          const SizedBox(width: kDefaultPadding / 2),
          type == MessageType.text.name
              ? Container(
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
                    color: sendByMe
                        ? kPrimaryColor
                        : kPrimaryColor.withOpacity(0.2),
                  ),
                  child: Text(message,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: sendByMe
                            ? kContentColorDarkTheme
                            : kContentColorLightTheme,
                        fontSize: 16,
                      )))
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FullPhoto(photoURL: message)));
                  },
                  child: Container(
                    width: 200,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: NetworkImage(message)),
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
