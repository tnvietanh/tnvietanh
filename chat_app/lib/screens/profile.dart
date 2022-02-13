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
import 'photo_view.dart';
import 'update_profile.dart';

class Profile extends StatefulWidget {
  static const routeName = 'profile';
  const Profile(
      {Key? key, required this.profileId, required this.usersProvider})
      : super(key: key);
  final String profileId;
  final UserProvider usersProvider;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? imageFile;

  void _imagePicker(ImageSource key) async {
    final pickerFile =
        await ImagePicker().pickImage(source: key, imageQuality: 25);
    if (pickerFile != null) {
      setState(() {
        imageFile = File(pickerFile.path);
      });
      uploadFile(File(pickerFile.path));
      Navigator.pop(context);
    }
  }

  void uploadFile(File file) async {
    UploadTask uploadTask =
        widget.usersProvider.uploadFile(file, 'avatar', widget.profileId);
    TaskSnapshot snapshot = await uploadTask;
    final photoURL = await snapshot.ref.getDownloadURL();
    widget.usersProvider.updateDataCurrentUser('photoURL', photoURL);
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text(
          //   "Thay đổi",
          //   style: TextStyle(color: kPrimaryColor),
          // ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                // const Divider(height: 2, color: kPrimaryColor),
                ListTile(
                  onTap: () {
                    _imagePicker(ImageSource.gallery);
                  },
                  title: const Text("Thư viện"),
                  leading: const Icon(
                    Icons.account_box,
                    color: kPrimaryColor,
                  ),
                ),
                const Divider(height: 2, color: kPrimaryColor),
                ListTile(
                  onTap: () {
                    _imagePicker(ImageSource.camera);
                  },
                  title: const Text("Máy ảnh"),
                  leading: const Icon(
                    Icons.camera,
                    color: kPrimaryColor,
                  ),
                ),
                const Divider(height: 2, color: kPrimaryColor),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullPhoto(
                                photoURL: widget.usersProvider
                                    .getDataSharedPreferences('photoURL'))));
                  },
                  title: const Text("Ảnh đại diện"),
                  leading: const Icon(
                    Icons.photo,
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
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                        : widget.usersProvider
                                    .getDataSharedPreferences('photoURL') !=
                                ''
                            ? Image.network(
                                widget.usersProvider
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
              stream: widget.usersProvider.getUser('id', widget.profileId),
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
                  return const SizedBox.shrink();
                }
              },
            ),
            const SizedBox(height: kDefaultPadding),
            Card(
              color:
                  isDarkMode ? Colors.grey.withOpacity(0.2) : Colors.grey[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              // color: kPrimaryColor,
              child: Column(
                children: [
                  BuildButton(
                    usersProvider: widget.usersProvider,
                    isLast: false,
                    text: 'Chế độ tối',
                    icon: Icons.dark_mode,
                    backgroundColor: kContentColorLightTheme,
                    onTap: () {},
                  ),
                  BuildButton(
                    usersProvider: widget.usersProvider,
                    isLast: false,
                    text: 'Trạng thái hoạt động',
                    icon: Icons.toggle_on,
                    backgroundColor: kPrimaryColor,
                  ),
                  BuildButton(
                    usersProvider: widget.usersProvider,
                    isLast: false,
                    text: 'Cài đặt tài khoản',
                    icon: Icons.build,
                    backgroundColor: Colors.grey,
                    onTap: () {
                      Navigator.pushNamed(context, UpdateProfile.routeName,
                          arguments: widget.usersProvider
                              .getDataSharedPreferences('userName'));
                    },
                  ),
                  BuildButton(
                    usersProvider: widget.usersProvider,
                    isLast: true,
                    text: 'Đăng xuất',
                    icon: Icons.logout,
                    backgroundColor: Colors.blue,
                    onTap: () {
                      Provider.of<AuthProvider>(context, listen: false)
                          .signOut();
                      widget.usersProvider
                          .updateDataCurrentUser('isOnline', false);
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

class BuildButton extends StatelessWidget {
  const BuildButton({
    Key? key,
    required this.isLast,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.usersProvider,
    this.onTap,
  }) : super(key: key);
  final UserProvider usersProvider;
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
                  stream: usersProvider.getUser(
                      'id', usersProvider.getDataSharedPreferences('id')),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Switch(
                        value: snapshot.data!.docs[0]['isOnline'],
                        onChanged: (_) {
                          if (usersProvider
                                  .getDataSharedPreferences('isOnline') ==
                              'true') {
                            usersProvider.updateDataCurrentUser(
                                'isOnline', false);
                          } else {
                            usersProvider.updateDataCurrentUser(
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
