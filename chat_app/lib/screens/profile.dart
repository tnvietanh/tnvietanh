import 'dart:io';

import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/screens/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../theme.dart';
import 'update_profile.dart';

class Profile extends StatefulWidget {
  static const routeName = 'profile';
  const Profile({Key? key, required this.currentId}) : super(key: key);
  final String currentId;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? imageFile;

  void _imagePicker(ImageSource key) async {
    final pickerFile = await ImagePicker().pickImage(source: key);
    if (pickerFile != null) {
      setState(() {
        imageFile = File(pickerFile.path);
      });
      uploadFile(File(pickerFile.path));
      Navigator.pop(context);
    } else {
      print('no file picked');
    }
  }

  void uploadFile(File file) async {
    UploadTask uploadTask = Provider.of<UsersProvider>(context, listen: false)
        .uploadFile(file, 'avatar', widget.currentId);
    TaskSnapshot snapshot = await uploadTask;
    final photoURL = await snapshot.ref.getDownloadURL();
    Provider.of<UsersProvider>(context, listen: false)
        .updateCurrentUser('photoURL', photoURL);
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Choose option",
            style: TextStyle(color: kPrimaryColor),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Divider(
                  height: 1,
                  color: kPrimaryColor,
                ),
                ListTile(
                  onTap: () {
                    _imagePicker(ImageSource.gallery);
                  },
                  title: const Text("Gallery"),
                  leading: const Icon(
                    Icons.account_box,
                    color: kPrimaryColor,
                  ),
                ),
                const Divider(
                  height: 1,
                  color: kPrimaryColor,
                ),
                ListTile(
                  onTap: () {
                    _imagePicker(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  title: const Text("Camera"),
                  leading: const Icon(
                    Icons.camera,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
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
                    onTap: () {
                      _showChoiceDialog(context);
                    },
                    child: imageFile != null
                        ? Image.file(
                            File(imageFile!.path),
                            fit: BoxFit.cover,
                          )
                        : Provider.of<UsersProvider>(context, listen: false)
                                    .getDataSharedPreferences('photoURL') !=
                                ''
                            ? Image.network(
                                Provider.of<UsersProvider>(context,
                                        listen: false)
                                    .getDataSharedPreferences('photoURL'),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/no_avatar.png',
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Provider.of<UsersProvider>(context, listen: false)
                  .getCurrentName(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!.docs[0]['userName'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return const Text('Error');
                }
              },
            ),
            const SizedBox(height: kDefaultPadding),
            Card(
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              // color: kPrimaryColor,
              child: Column(
                children: [
                  BuildButton(
                    isLast: false,
                    text: 'Dark Mode',
                    icon: Icons.dark_mode,
                    backgroundColor: kContentColorLightTheme,
                    onTap: () {},
                  ),
                  BuildButton(
                    isLast: false,
                    text: 'Active Status',
                    icon: Icons.toggle_on,
                    backgroundColor: kPrimaryColor,
                    onTap: () {},
                  ),
                  BuildButton(
                    isLast: false,
                    text: 'Account Setting',
                    icon: Icons.manage_accounts,
                    backgroundColor: Colors.grey,
                    onTap: () {
                      Navigator.pushNamed(context, UpdateProfile.routeName,
                          arguments:
                              Provider.of<UsersProvider>(context, listen: false)
                                  .getDataSharedPreferences('userName'));
                    },
                  ),
                  BuildButton(
                    isLast: true,
                    text: 'Sign Out',
                    icon: Icons.logout,
                    backgroundColor: Colors.blue,
                    onTap: () {
                      Provider.of<AuthProvider>(context, listen: false)
                          .signOut();
                      Provider.of<UsersProvider>(context, listen: false)
                          .updateCurrentUser('isOnline', false);
                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          AuthScreen.routeName,
                          (Route<dynamic> route) => false);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BuildButton extends StatefulWidget {
  const BuildButton({
    Key? key,
    required this.isLast,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    this.onTap,
  }) : super(key: key);

  final bool isLast;
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final void Function()? onTap;

  @override
  State<BuildButton> createState() => _BuildButtonState();
}

class _BuildButtonState extends State<BuildButton> {
  bool isSwitched = true;

  void toggleSwitch(bool value) {
    setState(() {
      if (isSwitched == false) {
        isSwitched = true;

        print('Switch Button is ON');
      } else {
        isSwitched = false;

        print('Switch Button is OFF');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: widget.onTap,
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
                        widget.icon,
                        color: kContentColorDarkTheme,
                      ),
                      radius: 18,
                      backgroundColor: widget.backgroundColor,
                    ),
                  ),
                  Text(widget.text),
                ],
              ),
              if (widget.text == 'Active Status' || widget.text == 'Dark Mode')
                Switch(
                  value: isSwitched,
                  activeColor: Colors.blue,
                  activeTrackColor: Colors.yellow,
                  inactiveThumbColor: Colors.redAccent,
                  inactiveTrackColor: Colors.orange,
                  onChanged: toggleSwitch,
                )
            ],
          ),
          if (!widget.isLast)
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
