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
    'photoURL': '',
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
    Provider.of<UsersProvider>(context, listen: false)
        .updateCurrentUser('userName', data['userName']);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Setting'),
        actions: [
          IconButton(
            onPressed: () {
              _saveUpdate(_dataNeedUpdate);
            },
            icon: const Icon(Icons.save),
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
                      label: Text('Name'),
                    ),
                    onSaved: (value) {
                      _dataNeedUpdate['userName'] = value ?? '';
                    },
                  ),
                  TextFormField(
                    initialValue: _dataNeedUpdate['photoURL'],
                    decoration: const InputDecoration(
                      label: Text('Photo URL'),
                    ),
                    onSaved: (value) {
                      _dataNeedUpdate['photoURL'] = value ?? '';
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
