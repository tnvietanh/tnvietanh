import 'package:app_flutter/model/foods.dart';
import 'package:app_flutter/provider.dart/food.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class FoodUpdateScreen extends StatefulWidget {
  static const routeName = '/update-food';
  final FoodItem? item;

  const FoodUpdateScreen({Key? key, this.item}) : super(key: key);

  @override
  _FoodUpdateScreenState createState() => _FoodUpdateScreenState();
}

class _FoodUpdateScreenState extends State<FoodUpdateScreen> {
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

    return snapshot.ref.getDownloadURL();
  }

  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _initValues = {
    'id': 1,
    'name': '',
    'kiloCalories': '',
    'protein': '',
    'fat': '',
    'carb': '',
    'image': ''
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
    final args = ModalRoute.of(this.context)!.settings.arguments as FoodItem?;
    if (args != null) {
      initValues(args);
    }
    super.didChangeDependencies();
  }

  void initValues(FoodItem? item) {
    _initValues['id'] = item?.id;
    _initValues['name'] = item?.name;
    _initValues['kiloCalories'] = item?.kiloCalories.toString();
    _initValues['image'] = item?.image;
    _initValues['protein'] = item?.protein;
    _initValues['fat'] = item?.fat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit '),
        actions: [
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
                  : IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () {
                        _saveForm();
                      },
                    );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
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
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _initValues['name'],
                    decoration: const InputDecoration(
                      labelText: 'Title',
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
                  TextFormField(
                      initialValue: _initValues['kiloCalories'],
                      decoration: const InputDecoration(
                        labelText: 'Kcal',
                      ),
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Please enter a number';
                        }
                        if (double.tryParse(value!) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _initValues['kiloCalories'] = value ?? '';
                      }),
                  const SizedBox(height: 10),
                  TextFormField(
                      initialValue: _initValues['protein'],
                      decoration: const InputDecoration(
                        labelText: 'Protein',
                      ),
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Please enter a number';
                        }
                        if (double.tryParse(value!) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _initValues['protein'] = value ?? '';
                      }),
                  const SizedBox(height: 10),
                  TextFormField(
                      initialValue: _initValues['fat'],
                      decoration: const InputDecoration(
                        labelText: 'Fat',
                      ),
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Please enter a number';
                        }
                        if (double.tryParse(value!) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _initValues['fat'] = value ?? '';
                      }),
                  const SizedBox(height: 10),
                  TextFormField(
                      initialValue: _initValues['carb'],
                      decoration: const InputDecoration(
                        labelText: 'Carb',
                      ),
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Please enter a number';
                        }
                        if (double.tryParse(value!) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _initValues['carb'] = value ?? '';
                      }),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  void _saveForm() async {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      _loading.value = true;
      if (_imageFile != null) {
        String url = await uploadImageToFirebase();
        _initValues['image'] = url;
      }
      final food = FoodItem(
          id: _initValues['id'].toString(),
          name: _initValues['name'],
          kiloCalories: double.parse(_initValues['kiloCalories']),
          protein: double.parse(_initValues['protein']),
          fat: double.parse(_initValues['fat']),
          quantity: 1,
          carb: double.parse(_initValues['carb']),
          image: _initValues['image']);
      final productProvider =
          Provider.of<FoodProvider>(this.context, listen: false);
      Future<void> future;

      future = productProvider.addFood(food);

      future.then((value) {
        _loading.value = false;
        return Navigator.pop(this.context, food);
      }).catchError((error) {
        ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(
          content: Text('Error saving product'),
        ));
        _loading.value = false;
      });
    }
  }
}

// class ImageFormField extends StatefulWidget {
//   final TextEditingController imageController;
//   final Function(String? value) onSaved;

//   const ImageFormField(
//       {Key? key, required this.imageController, required this.onSaved})
//       : super(key: key);

//   @override
//   _ImageFormFieldState createState() => _ImageFormFieldState();
// }

// class _ImageFormFieldState extends State<ImageFormField> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: <Widget>[
//         Stack(
//           children: <Widget>[
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                     border: Border.all(
//                         color: Colors.grey, width: 1, style: BorderStyle.solid),
//                     borderRadius: BorderRadius.circular(8)),
//                 child: widget.imageController.text.isNotEmpty
//                     ? Image(image: NetworkImage(widget.imageController.text))
//                     : const SizedBox(),
//               ),
//             ),
//             if (widget.imageController.text.isEmpty)
//               IconButton(
//                 icon: const Icon(Icons.photo_library),
//                 onPressed: () {},
//               ),
//           ],
//         ),
//         const SizedBox(width: 10),
//         Flexible(
//           fit: FlexFit.tight,
//           child: TextFormField(
//               controller: widget.imageController,
//               // initialValue: _initValues['image'],
//               decoration: const InputDecoration(
//                 labelText: 'Image URL',
//               ),
//               onChanged: (String? value) {
//                 setState(() {
//                   widget.imageController.text = value!;
//                 });
//               },
//               validator: (value) {
//                 if (value?.isEmpty == true) {
//                   return 'Please enter an image URL';
//                 }
//                 if ((!value!.startsWith('http') &&
//                     !value.startsWith('https'))) {
//                   return 'Please enter an valid image URL';
//                 }
//                 return null;
//               },
//               onSaved: widget.onSaved),
//         ),
//       ],
//     );
//   }
// }
