import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../theme.dart';
import 'update_profile.dart';

class Profile extends StatefulWidget {
  static const routeName = 'profile';
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  XFile? imageFile;
  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      imageFile = pickedFile;
    });

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      imageFile = pickedFile;
    });
    Navigator.pop(context);
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
                      _openGallery(context);
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
                      _openCamera(context);
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
        });
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
              child: FutureBuilder(
                future: Provider.of<UsersProvider>(context).getCurrentAvatar(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(56), // Image radius
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashFactory: NoSplash.splashFactory,
                          onTap: () {
                            _showChoiceDialog(context);
                          },
                          child:
                              Image.network(snapshot.data, fit: BoxFit.cover),
                        ),
                      ),
                    );
                  } else {
                    return const Text('Error');
                  }
                },
              ),
            ),
            FutureBuilder(
              future: Provider.of<UsersProvider>(context).getCurrentName(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data,
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
                  borderRadius: BorderRadius.circular(15.0)),
              // color: kPrimaryColor,
              child: Column(
                children: [
                  buildButton(
                    false,
                    'Dark Mode',
                    Icons.dark_mode,
                    kContentColorLightTheme,
                    () {},
                  ),
                  buildButton(
                    false,
                    'Active Status',
                    Icons.toggle_on,
                    kPrimaryColor,
                    () {},
                  ),
                  buildButton(
                    false,
                    'Account Setting',
                    Icons.manage_accounts,
                    Colors.grey,
                    () {
                      Navigator.pushNamed(
                        context,
                        UpdateProfile.routeName,
                      );
                    },
                  ),
                  buildButton(
                    true,
                    'Sign Out',
                    Icons.logout,
                    Colors.blue,
                    () {
                      Provider.of<AuthProvider>(context, listen: false)
                          .signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          WelcomeScreen.routeName,
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

Widget buildButton(
  bool isLast,
  String text,
  IconData icon,
  Color backgroundColor,
  void Function()? onTap,
) {
  return InkWell(
    highlightColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    onTap: onTap,
    child: Column(
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
            Text(text),
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
