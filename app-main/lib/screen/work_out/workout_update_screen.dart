import 'package:app_flutter/model/workout.dart';
import 'package:app_flutter/provider.dart/workout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkOutUpdateScreen extends StatefulWidget {
  static const routeName = '/update';
  final WorkOut? item;

  const WorkOutUpdateScreen({Key? key, this.item}) : super(key: key);

  @override
  _WorkOutUpdateScreenState createState() => _WorkOutUpdateScreenState();
}

class _WorkOutUpdateScreenState extends State<WorkOutUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _initValues = {
    'name': '',
    'kcalBurn': '',
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
    final args = ModalRoute.of(context)!.settings.arguments as WorkOut?;
    if (args != null) {
      initValues(args);
    }
    super.didChangeDependencies();
  }

  void initValues(WorkOut? item) {
    _initValues['id'] = item?.id;
    _initValues['name'] = item?.name;
    _initValues['kcalBurn'] = item?.kcalBurn.toString();
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
                        // Save product
                        _saveForm();
                      },
                    );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
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
                  initialValue: _initValues['kcalBurn'],
                  decoration: const InputDecoration(
                    labelText: 'Kcal Burn',
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
                    _initValues['kcalBurn'] = value ?? '';
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      _loading.value = true;
      final product = WorkOut(
        id: _initValues['id'].toString(),
        name: _initValues['name'],
        kcalBurn: double.parse(_initValues['kcalBurn']),
        quantity: 1,
      );
      final productProvider =
          Provider.of<WorkOutProvider>(context, listen: false);
      Future<void> future;

      future = productProvider.addProduct(product);

      future.then((value) {
        _loading.value = false;
        return Navigator.pop(context, product);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error saving product'),
        ));
        _loading.value = false;
      });
    }
  }
}
