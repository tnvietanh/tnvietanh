import 'package:chat_app/provider/user_provider.dart';
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
                  color: const Color(0xFFA8F5EE),
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                    icon: const Icon(Icons.person),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        Provider.of<UsersProvider>(context, listen: false)
                            .getUserByUserName(_searchController.text);
                        setState(() {});
                      },
                    ),
                    hintStyle: const TextStyle(color: Colors.grey),
                    hintText: "Search",
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: Provider.of<UsersProvider>(context, listen: false)
                    .getUserByUserName(_searchController.text),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        final result = snapshot.data.docs;
                        return Row(
                          children: [
                            Text(snapshot.data.docs[index]['userName']),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatRoom(
                                              currentId:
                                                  Provider.of<UsersProvider>(
                                                          context,
                                                          listen: false)
                                                      .getDataSharedPreferences(
                                                          'id'),
                                              userId: result[index]['id'],
                                              userName: result[index]
                                                  ['userName'])));
                                },
                                child: const Text('Chat'))
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                })
          ],
        ),
      ),
    );
  }
}
