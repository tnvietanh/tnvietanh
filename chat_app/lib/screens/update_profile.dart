import 'package:chat_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateProfile extends StatefulWidget {
  static const routeName = 'update_profile';
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _updateNameKey = GlobalKey<FormState>();
  final Map<String, dynamic> _dataNeedUpdate = {
    'userName': '',
  };
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      _dataNeedUpdate['userName'] = args;
    }
  }

  void _saveUpdate(data) {
    _updateNameKey.currentState?.save();
    Provider.of<UserProvider>(context, listen: false)
        .updateDataCurrentUser('userName', data['userName']);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Cài đặt'),
        actions: [
          IconButton(
            onPressed: () => _saveUpdate(_dataNeedUpdate),
            icon: const Icon(Icons.save),
            tooltip: 'Lưu',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: Form(
              key: _updateNameKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _dataNeedUpdate['userName'],
                    decoration: const InputDecoration(
                      label: Text('Tên'),
                    ),
                    onSaved: (value) {
                      _dataNeedUpdate['userName'] = value ?? '';
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
