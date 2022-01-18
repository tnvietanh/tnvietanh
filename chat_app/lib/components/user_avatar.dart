import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key, required this.stream}) : super(key: key);
  final Stream<QuerySnapshot> stream;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData == false ||
            snapshot.data.docs[0]['photoURL'] == '') {
          return Image.asset('assets/images/no_avatar.png', fit: BoxFit.cover);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Image.network(snapshot.data.docs[0]['photoURL'],
              fit: BoxFit.cover);
        }
      },
    );
  }
}
