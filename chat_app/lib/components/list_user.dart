import 'package:chat_app/components/user_avatar.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/screens/chat_room.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListUser extends StatelessWidget {
  const ListUser(
      {Key? key,
      required this.selectedIndex,
      required this.currentId,
      required this.usersProvider})
      : super(key: key);
  final int selectedIndex;
  final String currentId;
  final UserProvider usersProvider;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: usersProvider.getAllUser(),
        builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
          if (userSnapshot.hasData) {
            final listUser = userSnapshot.data!.docs;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedIndex == 0)
                  BuildListUserHorizontal(
                    currentId: currentId,
                    usersProvider: usersProvider,
                    listUser: listUser,
                  ),
                Expanded(
                  flex: 10,
                  child: ListView.builder(
                    itemCount: listUser.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (selectedIndex == 0) {
                        return StreamBuilder(
                          stream: usersProvider
                              .getUserChattingWith(listUser[index]['id']),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> chattingSnapshot) {
                            if (chattingSnapshot.hasData &&
                                chattingSnapshot.data!.docs.isNotEmpty) {
                              return buildUser(
                                usersProvider,
                                context,
                                listUser[index],
                                currentId,
                                selectedIndex,
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        );
                      } else {
                        return buildUser(
                          usersProvider,
                          context,
                          listUser[index],
                          currentId,
                          selectedIndex,
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class BuildListUserHorizontal extends StatelessWidget {
  const BuildListUserHorizontal({
    Key? key,
    required this.listUser,
    required this.usersProvider,
    required this.currentId,
  }) : super(key: key);
  final List<QueryDocumentSnapshot<Object?>> listUser;
  final UserProvider usersProvider;
  final String currentId;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.only(
            top: kDefaultPadding / 2,
            left: kDefaultPadding / 2,
            bottom: kDefaultPadding / 2),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: listUser.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (listUser[index]['id'] != currentId)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoom(
                            userProvider: usersProvider,
                            document: listUser[index],
                            currentId: currentId,
                          ),
                        ),
                      );
                    },
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                UserAvatar(
                                    size: 26,
                                    stream: usersProvider.getUser(
                                        'id', listUser[index]['id'])),
                                StreamBuilder(
                                  stream:
                                      usersProvider.getUser('id', currentId),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.docs[0]['isOnline'] ==
                                            true &&
                                        listUser[index]['isOnline']) {
                                      return Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          height: 16,
                                          width: 16,
                                          decoration: BoxDecoration(
                                            color: kSecondaryColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                width: 3),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                )
                              ],
                            ),
                            const SizedBox(height: kDefaultPadding / 4),
                            SizedBox(
                              width: 52,
                              child: Text(
                                listUser[index]['userName'].split(' ').first,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            if (listUser[index]['userName'].indexOf(' ') > 0)
                              SizedBox(
                                width: 52,
                                child: Text(
                                  listUser[index]['userName'].substring(
                                      listUser[index]['userName'].indexOf(' ')),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
