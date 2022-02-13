import 'package:chat_app/models/user.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/screens/photo_library.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({
    Key? key,
    required this.userDocument,
    required this.userProvider,
    required this.chatRoomId,
  }) : super(key: key);
  final DocumentSnapshot userDocument;
  final UserProvider userProvider;
  final String chatRoomId;
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    UserModel userModel = UserModel.fromDocument(widget.userDocument);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  bottom: kDefaultPadding / 2,
                ),
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(56), // Image radius
                    child: InkWell(
                        highlightColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                        onTap: () {},
                        child: Image.network(
                          userModel.photoURL,
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
              ),
              Text(
                userModel.userName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: kDefaultPadding),
              Card(
                color: isDarkMode
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.grey[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                // color: kPrimaryColor,
                child: Column(
                  children: [
                    BuildButton(
                      userProvider: widget.userProvider,
                      isLast: false,
                      text: 'Chủ đề',
                      icon: Icons.trip_origin,
                      backgroundColor: Colors.red,
                    ),
                    BuildButton(
                      userProvider: widget.userProvider,
                      isLast: false,
                      text: 'Biểu tượng cảm xúc',
                      icon: Icons.emoji_emotions,
                      backgroundColor: kPrimaryColor,
                    ),
                    BuildButton(
                      userProvider: widget.userProvider,
                      isLast: false,
                      text: 'Biệt danh',
                      icon: Icons.manage_accounts,
                      backgroundColor: Colors.grey,
                      onTap: () {},
                    ),
                    BuildButton(
                      userProvider: widget.userProvider,
                      isLast: false,
                      text: 'Xem ảnh & video',
                      icon: Icons.photo_library,
                      backgroundColor: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhotoLibrary(
                              userProvider: widget.userProvider,
                              chatRoomId: widget.chatRoomId,
                              userName: userModel.userName,
                            ),
                          ),
                        );
                      },
                    ),
                    BuildButton(
                      userProvider: widget.userProvider,
                      isLast: true,
                      text: 'Tìm kiếm trong cuộc trò chuyện',
                      icon: Icons.search,
                      backgroundColor: Colors.blue,
                      onTap: () {},
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BuildButton extends StatelessWidget {
  const BuildButton({
    Key? key,
    required this.isLast,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.userProvider,
    this.onTap,
  }) : super(key: key);
  final UserProvider userProvider;
  final bool isLast;
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return InkWell(
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding / 2,
                        vertical: kDefaultPadding / 2),
                    child: CircleAvatar(
                      child: Icon(
                        icon,
                        color: kContentColorDarkTheme,
                      ),
                      radius: 18,
                      backgroundColor: backgroundColor,
                    ),
                  ),
                  Text(
                    text,
                    style: isDarkMode
                        ? const TextStyle(color: kContentColorDarkTheme)
                        : const TextStyle(color: kContentColorLightTheme),
                  ),
                ],
              ),
              if (text == 'Trạng thái hoạt động')
                StreamBuilder(
                  stream: userProvider.getUser(
                      'id', userProvider.getDataSharedPreferences('id')),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Switch(
                        value: snapshot.data!.docs[0]['isOnline'],
                        onChanged: (_) {
                          if (userProvider
                                  .getDataSharedPreferences('isOnline') ==
                              'true') {
                            userProvider.updateDataCurrentUser(
                                'isOnline', false);
                          } else {
                            userProvider.updateDataCurrentUser(
                                'isOnline', true);
                          }
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                )
            ],
          ),
          if (!isLast)
            Container(
              margin: const EdgeInsets.only(left: 56),
              color: Colors.grey,
              height: 1,
            )
        ],
      ),
    );
  }
}
