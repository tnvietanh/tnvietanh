import 'package:chat_app/components/user_avatar.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_room.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = 'search_screen';
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        width: deviceWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: deviceWidth * 0.8,
              padding: EdgeInsets.symmetric(horizontal: deviceHeight * 0.02),
              decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey : kPrimaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                    icon: const Icon(Icons.person),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        Provider.of<UserProvider>(context, listen: false)
                            .getUser('userName', _searchController.text);
                        setState(() {});
                      },
                    ),
                    hintStyle: TextStyle(
                        color:
                            isDarkMode ? kContentColorLightTheme : Colors.grey),
                    hintText: "Search",
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Provider.of<UserProvider>(context, listen: false)
                  .getUser('userName', _searchController.text),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        final user = snapshot.data.docs;
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatRoom(
                                  userProvider: Provider.of<UserProvider>(
                                      context,
                                      listen: false),
                                  document: user[index],
                                  currentId: Provider.of<UserProvider>(context,
                                          listen: false)
                                      .getDataSharedPreferences('id'),
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              UserAvatar(
                                  stream: Provider.of<UserProvider>(context,
                                          listen: false)
                                      .getUser(
                                          'userName', _searchController.text),
                                  size: 26),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(user[index]['userName']),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
