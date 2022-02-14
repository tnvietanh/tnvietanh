import 'package:app_flutter/model/user.dart';
import 'package:app_flutter/provider.dart/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class UpdateProfileScreen extends StatefulWidget {
  static const routeName = '/update-user';
  final UserModel? item;
  const UpdateProfileScreen({Key? key, this.item}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  File? _imageFile;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future uploadImageToFirebase() async {
    String fileName = basename(_imageFile!.path);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('uploads')
        .child('/$fileName');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName});
    firebase_storage.UploadTask uploadTask;
    //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    uploadTask = ref.putFile(io.File(_imageFile!.path), metadata);

    firebase_storage.UploadTask task = await Future.value(uploadTask);
    final snapshot = await task.whenComplete(() {});
    // snapshot.ref.getDownloadURL().then(
    //   (value) {
    //     setState(() {
    //       _uploadedFileURL = value;
    //     });
    //   },
    // );
    return snapshot.ref.getDownloadURL();
  }

  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _initValues = {
    'id': -1,
    'name': '',
    'profileImage': '',
  };
  final ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  @override
  void initState() {
    if (widget.item != null) {
      initValues(widget.item);
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(this.context)!.settings.arguments as UserModel?;
    if (args != null) {
      initValues(args);
    }
    super.didChangeDependencies();
  }

  void initValues(UserModel? item) {
    _initValues['id'] = item?.id;
    _initValues['name'] = item?.name;
    _initValues['profileImage'] = item?.profileImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.purple[200],
                      radius: 75,
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: SizedBox(
                        height: 130,
                        width: 130,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(80.0),
                            child: _imageFile != null
                                ? GestureDetector(
                                    onTap: () {
                                      pickImage;
                                    },
                                    child: Image.file(
                                      _imageFile!,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: pickImage,
                                    icon: const Icon(
                                      Icons.person,
                                      color: Colors.blue,
                                      size: 50,
                                    ),
                                  )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: _initValues['name'],
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (String? value) {
                    if (value?.isEmpty == true) {
                      return 'Title is required';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _initValues['name'] = value ?? '';
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _loading,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return value
                        ? const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.red,
                                strokeWidth: 3,
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              _saveForm();
                            },
                            child: const Text('Save Profile'));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveForm() async {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      _loading.value = true;
      if (_imageFile != null) {
        String url = await uploadImageToFirebase();
        _initValues['profileImage'] = url;
      }
      final product = UserModel(
        id: _initValues['id'].toString(),
        name: _initValues['name'],
        profileImage: _initValues['profileImage']!,
      );
      final productProvider =
          Provider.of<UserProvider>(this.context, listen: false);
      Future<void> future;
      if (_initValues['id'] == -1) {
        future = productProvider.addProduct(product);
      } else {
        future = productProvider.updateProduct(product);
      }
      future.then((value) {
        _loading.value = false;
        return Navigator.pop(this.context, product);
      }).catchError((error) {
        ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(
          content: Text('Error saving product'),
        ));
        _loading.value = false;
      });
    }
  }
}
