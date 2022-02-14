// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_core/firebase_core.dart';

// class ProfileScreen extends StatefulWidget {
//   static const routeName = '/profile';
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final textcontroller = TextEditingController();
//   final databaseRef = FirebaseDatabase.instance.ref();
//   final Future<FirebaseApp> _future = Firebase.initializeApp();

//   void addData(String data) {
//     databaseRef.push().set({'name': data, 'comment': 'A good season'});
//   }

//   // void printFirebase() {
//   //   databaseRef
//   //       .once()
//   //       .then((DataSnapshot snapshot) => print('Data : ${snapshot.value}'));
//   // }

//   @override
//   Widget build(BuildContext context) {
//     // printFirebase();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Firebase Demo"),
//       ),
//       body: FutureBuilder(
//           future: _future,
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Text(snapshot.error.toString());
//             } else {
//               return Container(
//                 child: Column(
//                   children: <Widget>[
//                     SizedBox(height: 250.0),
//                     Padding(
//                       padding: EdgeInsets.all(10.0),
//                       child: TextField(
//                         controller: textcontroller,
//                       ),
//                     ),
//                     SizedBox(height: 30.0),
//                     Center(
//                         child: RaisedButton(
//                             color: Colors.pinkAccent,
//                             child: Text("Save to Database"),
//                             onPressed: () {
//                               addData(textcontroller.text);
//                               //call method flutter upload
//                             })),
//                   ],
//                 ),
//               );
//             }
//           }),
//     );
//   }
// }

import 'package:app_flutter/provider.dart/google_sign_in.dart';
import 'package:app_flutter/provider.dart/user.dart';
import 'package:app_flutter/local_notification.dart';
import 'package:app_flutter/screen/update_profile_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Future pickImage(ImageSource source) async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: source);
  //     if (image == null) return;
  //     final imageTemporary = File(image.path);
  //     setState(() => this.image = imageTemporary);
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('Settings Screen'),
        ),
        backgroundColor: Colors.grey[150],
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Stack(
                    children: [
                      const SizedBox(
                        height: 150,
                        width: double.infinity,
                      ),
                      const Center(
                        child: CircleAvatar(
                          radius: 65,
                          child: Icon(Icons.person),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 0,
                        child: CircleAvatar(
                          child: IconButton(
                            onPressed: () async {
                              final result = Navigator.pushNamed(
                                context,
                                UpdateProfileScreen.routeName,
                              );
                              debugPrint('$result');
                            },
                            icon: Icon(
                              Icons.edit_outlined,
                              color: Colors.indigo[800],
                            ),
                          ),
                          backgroundColor: Colors.indigo[100],
                          radius: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 45,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SettingCard(
                      title: 'Account Information',
                      onTap: () {},
                      icon: const Icon(Icons.person),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SettingCard(
                        icon: const Icon(Icons.doorbell_rounded),
                        title: 'Local Notifications',
                        onTap: () => NotificationApi.showNotification(
                            title: 'daa aa',
                            body: 'adads ad asds as dasdsfgnn ',
                            payload: 'daa.aa')),
                    const SizedBox(
                      height: 15,
                    ),
                    SettingCard(
                        icon: const Icon(Icons.logout_rounded),
                        title: 'Logout',
                        onTap: () {
                          Provider.of<GoogleSignInProvider>(context,
                                  listen: false)
                              .logout();
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  // Widget bottomSheet() {
  //   return Column(mainAxisSize: MainAxisSize.min, children: [
  //     ListTile(
  //       leading: const Icon(Icons.camera_alt),
  //       title: const Text('Camera'),
  //       onTap: pickImage,
  //     ), // ListTile
  //     ListTile(
  //       leading: const Icon(Icons.image),
  //       title: const Text('Gallery'),
  //       onTap: () {},
  //     )
  //   ]);
  // }

}

class SettingCard extends StatelessWidget {
  final String title;
  final Function onTap;
  final Icon icon;

  const SettingCard(
      {Key? key, required this.title, required this.onTap, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: ListTile(
        leading: icon,
        title: Text(title),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios_rounded),
          onPressed: () => onTap,
        ),
      ),
    );
  }
}
