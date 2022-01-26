import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key, required this.stream, required this.size})
      : super(key: key);
  final Stream<QuerySnapshot> stream;
  final double size;
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox.fromSize(
        size: Size.fromRadius(size), // Image radius
        child: StreamBuilder<QuerySnapshot>(
          stream: stream,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData == false ||
                snapshot.data.docs[0]['photoURL'] == '') {
              return Image.asset('assets/images/no_avatar.png',
                  fit: BoxFit.cover);
            } else {
              return Image.network(snapshot.data.docs[0]['photoURL'],
                  fit: BoxFit.cover);
            }
          },
        ),
      ),
    );
  }
}
