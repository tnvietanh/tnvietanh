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
                      .getDataUser('id', currentId)),
            ),
          ),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(profileId: currentId),
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
          _selectedIndex == 2
              ? const Center(child: Text('...developing...'))
              : _selectedIndex == 1 &&
                      Provider.of<UsersProvider>(context, listen: false)
                              .getDataSharedPreferences('isOnline') ==
                          'false'
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPadding * 12,
                          horizontal: kDefaultPadding * 2),
                      child: Column(
                        children: [
                          const Text(
                            'Xem những ai đang hoạt động',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Cho mọi người biết khi bạn đang hoạt động, hoạt động gần đây hoặc có mặt trong cùng đoạn chat với họ. Bạn cũng sẽ biết khi họ như vậy.',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Provider.of<UsersProvider>(context,
                                        listen: false)
                                    .updateDataCurrentUser('isOnline', true);
                                setState(() {});
                              },
                              child: const Text('Bật'))
                        ],
                      ),
                    )
                  : Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream:
                            Provider.of<UsersProvider>(context, listen: false)
                                .getAllUser(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> userSnapshot) {
                          if (userSnapshot.hasData) {
                            final listUser = userSnapshot.data!.docs;
                            return ListView.builder(
                              itemCount: listUser.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                if (_selectedIndex == 0) {
                                  return StreamBuilder(
                                    stream: Provider.of<UsersProvider>(context,
                                            listen: false)
                                        .getUserChattingWith(
                                            listUser[index]['id']),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot>
                                            chattingSnapshot) {
                                      if (chattingSnapshot.hasData &&
                                          chattingSnapshot
                                              .data!.docs.isNotEmpty) {
                                        return buildUser(
                                          context,
                                          listUser[index],
                                          currentId,
                                          _selectedIndex,
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
                                  );
                                } else {
                                  return buildUser(
                                    context,
                                    listUser[index],
                                    currentId,
                                    _selectedIndex,
                                  );
                                }
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

Widget buildUser(
  BuildContext context,
  DocumentSnapshot? document,
  String currentId,
  int selectedIndex,
) {
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
                  document: document,
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
                                .getDataUser('id', userModel.id),
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
                      if (selectedIndex == 0)
                        buildLastMessage(context, userModel.id,
                            userModel.userName, currentId)
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

Widget buildLastMessage(
  BuildContext context,
  String userId,
  String userName,
  String currentId,
) {
  return StreamBuilder<QuerySnapshot>(
    stream:
        Provider.of<UsersProvider>(context, listen: false).getMessages(userId),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData) {
        List<QueryDocumentSnapshot> listMessage = snapshot.data!.docs;
        if (listMessage.isNotEmpty) {
          if (listMessage.first['type'] == 'text') {
            return Text(listMessage.first['message']);
          } else if (listMessage.first['idFrom'] == currentId) {
            return const Text('You sent a photo.');
          } else if (listMessage.first['idFrom'] == userId) {
            return Text('${userName.split(' ').last} sent a photo.');
          } else {
            return const SizedBox.shrink();
          }
        } else {
          return const SizedBox.shrink();
        }
      } else {
        return const SizedBox.shrink();
      }
    },
  );
}
