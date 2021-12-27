import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/list_products.dart';
import '../../models/product.dart';
import '../../widgets/loading.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/edit_product';
  const EditProduct({Key? key}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _formKey = GlobalKey<FormState>();
  final imageUrlController = TextEditingController();

  final Map<String, dynamic> _initValues = {
    'id': '',
    'title': '',
    'price': '',
    'desc': '',
    'imageUrl': '',
  };

  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  void _saveForm() {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      _isLoading.value = true;
      final product = Product(
          id: _initValues['id'].toString(),
          title: _initValues['title'],
          price: double.parse(_initValues['price']),
          desc: _initValues['desc'],
          quantity: 1,
          imageUrl: _initValues['imageUrl']);
      Future<void> future;
      final productsProvider = Provider.of<Products>(context, listen: false);
      final items = Provider.of<Products>(context, listen: false).items;
      final prodIndex = items.indexWhere((e) => e.id == product.id);
      if (prodIndex < 0) {
        future = productsProvider.addProduct(product);
      } else {
        future = productsProvider.updateProduct(product);
      }
      future.then((value) {
        _isLoading.value = false;
        return Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving product'),
          ),
        );
        _isLoading.value = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    imageUrlController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Product?;
    if (args != null) {
      _initValues['id'] = args.id;
      _initValues['title'] = args.title;
      _initValues['price'] = args.price.toString();
      _initValues['desc'] = args.desc;
      _initValues['imageUrl'] = args.imageUrl;
      imageUrlController.text = args.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product'),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          actions: [
            ValueListenableBuilder<bool>(
              valueListenable: _isLoading,
              builder: (BuildContext context, bool value, Widget? child) {
                return value
                    ? Center(
                        child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            width: 24,
                            height: 24,
                            child: const ColorLoader2(
                                color1: Colors.deepOrangeAccent,
                                color2: Colors.yellow,
                                color3: Colors.lightGreen)),
                      )
                    : IconButton(
                        icon: const Icon(Icons.save),
                        onPressed: () {
                          // Save product
                          _saveForm();
                        },
                      );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _initValues['title'],
                    decoration: const InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide a value.';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (String? value) {
                      _initValues['title'] = value ?? '';
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['price'],
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a price.';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (String? value) {
                      _initValues['price'] = value ?? '';
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['desc'],
                    decoration: const InputDecoration(labelText: 'Description'),
                    textInputAction: TextInputAction.next,
                    maxLines: 3,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description.';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (String? value) {
                      _initValues['desc'] = value ?? '';
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        child: imageUrlController.text.isEmpty
                            ? const Center(
                                child: Text('Enter a URL'),
                              )
                            : FittedBox(
                                child: Image.network(imageUrlController.text,
                                    fit: BoxFit.cover),
                              ),
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(top: 8, right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: imageUrlController,
                          decoration:
                              const InputDecoration(labelText: 'Image URL'),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (image) {
                            setState(() {});
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an image URL.';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (String? value) {
                            _initValues['imageUrl'] = value ?? '';
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
