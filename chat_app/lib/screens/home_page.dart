import 'package:chat_app/components/list_user.dart';
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
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Mọi người',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.call),
          label: 'Cuộc gọi',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UserProvider>(context, listen: false);
    final currentId = usersProvider.getDataSharedPreferences('id');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: UserAvatar(
              size: 20, stream: usersProvider.getUser('id', currentId)),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(
                  profileId: currentId,
                  usersProvider: usersProvider,
                ),
              )),
        ),
        automaticallyImplyLeading: false,
        title: Text(_selectedIndex == 0
            ? 'Chat'
            : _selectedIndex == 1
                ? 'Mọi người'
                : 'Cuộc gọi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.routeName);
            },
          ),
        ],
      ),
      body: _selectedIndex == 2
          ? const Center(child: Text('Đang phát triển.'))
          : Column(
              children: [
                _selectedIndex == 1
                    ? CheckStatus(
                        usersProvider: usersProvider,
                        currentId: currentId,
                        selectedIndex: _selectedIndex)
                    : ListUser(
                        usersProvider: usersProvider,
                        selectedIndex: _selectedIndex,
                        currentId: currentId)
              ],
            ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}

Widget buildUser(
  UserProvider userProvider,
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
          left: kDefaultPadding / 2,
          right: kDefaultPadding / 2,
          top: kDefaultPadding / 2,
        ),
        child: InkWell(
          onLongPress: () {
            userProvider.deleteChatRoom(userModel.id);
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatRoom(
                  userProvider: userProvider,
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
                  UserAvatar(
                    size: 26,
                    stream: Provider.of<UserProvider>(context, listen: false)
                        .getUser('id', userModel.id),
                  ),
                  if (userModel.isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
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
        Provider.of<UserProvider>(context, listen: false).getMessages(userId),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData) {
        List<QueryDocumentSnapshot> listMessage = snapshot.data!.docs;
        if (listMessage.isNotEmpty) {
          if (listMessage.first['type'] == 'text') {
            return Text(
              listMessage.first['message'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
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

class CheckStatus extends StatelessWidget {
  const CheckStatus(
      {Key? key,
      required this.usersProvider,
      required this.currentId,
      required this.selectedIndex})
      : super(key: key);
  final UserProvider usersProvider;
  final String currentId;
  final int selectedIndex;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: usersProvider.getUser('id', currentId),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData &&
            selectedIndex == 1 &&
            snapshot.data!.docs[0]['isOnline'] == false) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: kDefaultPadding * 12,
                horizontal: kDefaultPadding * 2),
            child: Column(
              children: [
                const Text(
                  titleStatusOff,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  statusOffText,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () {
                    usersProvider.updateDataCurrentUser('isOnline', true);
                  },
                  child: const Text('Bật'),
                )
              ],
            ),
          );
        } else {
          return ListUser(
            usersProvider: usersProvider,
            selectedIndex: selectedIndex,
            currentId: currentId,
          );
        }
      },
    );
  }
}
