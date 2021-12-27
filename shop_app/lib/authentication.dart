import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/auth.dart';
import './widgets/loading.dart';

enum AuthMode { signUp, login }

class SetForm extends StatefulWidget {
  const SetForm({Key? key}) : super(key: key);
  @override
  State<SetForm> createState() => _LoginSetFormState();
}

class _LoginSetFormState extends State<SetForm> {
  AuthMode _authMode = AuthMode.login;
  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              if (_authMode == AuthMode.signUp)
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                ),
              Provider.of<AuthProvider>(context, listen: true).isLoading
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 25),
                      width: 24,
                      height: 24,
                      child: const ColorLoader2(
                          color1: Colors.deepOrangeAccent,
                          color2: Colors.yellow,
                          color3: Colors.lightGreen))
                  : ElevatedButton(
                      onPressed: () {
                        if (_authMode == AuthMode.login) {
                          Provider.of<AuthProvider>(context, listen: false)
                              .login(
                            _emailController.text,
                            _passwordController.text,
                          );
                        } else {
                          Provider.of<AuthProvider>(context, listen: false)
                              .signUp(
                            _emailController.text,
                            _passwordController.text,
                          );
                        }
                      },
                      child: Text(
                          _authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP'),
                    ),
              Provider.of<AuthProvider>(context, listen: true).isLoading
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 25),
                      width: 24,
                      height: 24,
                      child: const ColorLoader2(
                          color1: Colors.deepOrangeAccent,
                          color2: Colors.yellow,
                          color3: Colors.lightGreen))
                  : TextButton(
                      onPressed: _switchAuthMode,
                      child: Text(_authMode == AuthMode.login
                          ? 'Sign up'
                          : 'Login Instead'),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
