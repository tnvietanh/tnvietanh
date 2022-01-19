import 'package:chat_app/components/user_avatar.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';

import 'chat_room.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'home_page';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.messenger),
          label: "Chats",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: "People",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.call),
          label: "Calls",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentId = Provider.of<UsersProvider>(context, listen: false)
        .getDataSharedPreferences('id');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: ClipOval(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(20), // Image radius
              child: UserAvatar(
                  stream: Provider.of<UsersProvider>(context, listen: false)
                      .getUserAvatar(currentId)),
            ),
          ),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(currentId: currentId),
              )),
        ),
        automaticallyImplyLeading: false,
        title: const Text("Chat"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.routeName);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Provider.of<UsersProvider>(context, listen: false)
                  .getAllUser(),
              builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
                if (userSnapshot.hasData) {
                  final listUser = userSnapshot.data!.docs;
                  return ListView.builder(
                    itemCount: listUser.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return StreamBuilder(
                        stream:
                            Provider.of<UsersProvider>(context, listen: false)
                                .getUserChattingWith(listUser[index]['id']),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> chatting) {
                          if (chatting.hasData &&
                              chatting.data!.docs.isNotEmpty) {
                            return buildUser(
                              context,
                              listUser[index],
                              currentId,
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      );
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}

Widget buildUser(context, DocumentSnapshot? document, currentId) {
  if (document == null) {
    return const SizedBox.shrink();
  } else {
    UserModel userModel = UserModel.fromDocument(document);
    if (userModel.id == currentId) {
      return const SizedBox.shrink();
    } else {
      return Container(
        padding: const EdgeInsets.only(
            left: kDefaultPadding * 0.5,
            right: kDefaultPadding * 0.5,
            top: kDefaultPadding * 0.5),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatRoom(
                  userId: userModel.id,
                  userName: userModel.userName,
                  currentId: currentId,
                ),
              ),
            );
          },
          child: Row(
            children: [
              Stack(
                children: [
                  ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(20), // Image radius
                      child: UserAvatar(
                        stream:
                            Provider.of<UsersProvider>(context, listen: false)
                                .getUserAvatar(userModel.id),
                      ),
                    ),
                  ),
                  if (userModel.isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 3),
                        ),
                      ),
                    )
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userModel.userName,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      buildLastMessage(context, userModel.id)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

Widget buildLastMessage(BuildContext context, userId) {
  return StreamBuilder<QuerySnapshot>(
    stream:
        Provider.of<UsersProvider>(context, listen: false).getMessages(userId),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData) {
        List<QueryDocumentSnapshot> listMessage = snapshot.data!.docs;
        if (listMessage.isNotEmpty) {
          return Text(
            listMessage.first['message'],
          );
        } else {
          return const SizedBox.shrink();
        }
      } else {
        return const SizedBox.shrink();
      }
    },
  );
}
