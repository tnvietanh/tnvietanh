import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PhotoLibrary extends StatelessWidget {
  const PhotoLibrary({
    Key? key,
    required this.chatRoomId,
    required this.userProvider,
    required this.userName,
  }) : super(key: key);
  final String chatRoomId;
  final UserProvider userProvider;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Ảnh & video'),
      ),
      body: StreamBuilder(
        stream: userProvider.getAllImage(chatRoomId),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final listImage = snapshot.data!.docs;
            if (listImage.isNotEmpty) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                ),
                itemCount: listImage.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    listImage[index]['imageUrl'],
                    fit: BoxFit.cover,
                  );
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 56),
                    const SizedBox(height: kDefaultPadding),
                    const Text(
                      'Không có file phương tiện nào',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: kDefaultPadding),
                    Text('Ảnh của bạn và $userName sẽ xuất hiện ở đây.')
                  ],
                ),
              );
            }
          } else {
            return const Text('Error');
          }
        },
      ),
    );
  }
}
