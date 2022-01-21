import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullPhoto extends StatelessWidget {
  const FullPhoto({Key? key, required this.photoURL}) : super(key: key);
  final String photoURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: PhotoView(
        imageProvider: NetworkImage(photoURL),
      ),
    );
  }
}
