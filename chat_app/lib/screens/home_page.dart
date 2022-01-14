import 'package:chat_app/models/user.dart';
import 'package:chat_app/provider/auth_provider.dart';
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
  Stream<QuerySnapshot>? chatRooms;
  String? currentId;

  @override
  void initState() {
    super.initState();
    getChatRooms();
  }

  void getChatRooms() async {
    await Provider.of<UsersProvider>(context, listen: false)
        .getAllUser()
        .then((snapshots) {
      setState(() {
        currentId = Provider.of<AuthProvider>(context, listen: false)
            .getIdSharedPreferences();
        chatRooms = snapshots;
      });
    });
  }

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
        BottomNavigationBarItem(icon: Icon(Icons.messenger), label: "Chats"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "People"),
        BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const CircleAvatar(
            radius: 16,
            backgroundColor: kContentColorLightTheme,
          ),
          onPressed: () {
            Navigator.pushNamed(context, Profile.routeName);
          },
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
              stream: chatRooms,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final result = snapshot.data?.docs;
                  return ListView.builder(
                      itemCount: result!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          buildItem(context, result[index], currentId));
                } else {
                  return Container();
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

Widget buildItem(context, DocumentSnapshot? document, currentId) {
  if (document != null) {
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
          child: Row(
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: kContentColorLightTheme,
                  ),
                  // if (userModel.isActive)
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
                      Opacity(
                        opacity: 0.64,
                        child: Text(
                          userModel.id,
                          // maxLines: 1,
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatRoom(
                  userId: userModel.id,
                  userName: userModel.userName,
                ),
              ),
            );
          },
        ),
      );
    }
  } else {
    return const SizedBox.shrink();
  }
}
