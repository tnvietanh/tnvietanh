import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';

enum AuthMode { signUp, login }

class AuthScreen extends StatefulWidget {
  static const routeName = 'authentication_screen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isObscure = true;
  final bool _isLoading = false;
  AuthMode _authMode = AuthMode.login;

  @override
  void initState() {
    super.initState();
  }

  void _switchAuthMode() {
    setState(() {
      if (_authMode == AuthMode.login) {
        _authMode = AuthMode.signUp;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  // void _displaySuccessMotionToast() async {
  //   MotionToast.success(
  //       title: "Login Success",
  //       titleStyle: const TextStyle(fontWeight: FontWeight.bold),
  //       description: "Example of success motion toast",
  //       descriptionStyle: const TextStyle(fontSize: 12),
  //       layoutOrientation: ORIENTATION.rtl,
  //       animationType: ANIMATION.fromRight,
  //       width: 300,
  //       onClose: () {
  //         _displayWarningMotionToast();
  //       }).show(context);
  // }

  // void _displayWarningMotionToast() {
  //   MotionToast.warning(
  //     title: 'Warning Motion Toast',
  //     titleStyle: TextStyle(fontWeight: FontWeight.bold),
  //     description: 'This is a Warning',
  //     animationCurve: Curves.bounceIn,
  //     borderRadius: 0,
  //     animationDuration: Duration(milliseconds: 1000),
  //   ).show(context);
  // }

  // void _displayErrorMotionToast() {
  //   MotionToast.error(
  //     title: 'Error',
  //     titleStyle: TextStyle(fontWeight: FontWeight.bold),
  //     description: 'Please enter your name',
  //     animationType: ANIMATION.fromLeft,
  //     position: MOTION_TOAST_POSITION.top,
  //     width: 300,
  //   ).show(context);
  // }

  void submit() async {
    if (_formKey.currentState?.validate() == true) {
      if (_authMode == AuthMode.login) {
        bool isSuccess =
            await Provider.of<AuthProvider>(context, listen: false).login(
          _emailController.text,
          _passwordController.text,
        );
        if (isSuccess) {
          // _displaySuccessMotionToast();
          Navigator.pushNamed(context, HomePage.routeName);
        } else {
          // _displayErrorMotionToast();
        }
      } else {
        Provider.of<AuthProvider>(context, listen: false)
            .signup(
          _userNameController.text,
          _emailController.text,
          _passwordController.text,
        )
            .then((value) {
          setState(() {
            _authMode = AuthMode.login;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              width: deviceWidth * 0.8,
              top: 0,
              left: 0,
              child: Image.asset('assets/images/top.png'),
            ),
            Positioned(
              width: deviceWidth * 0.8,
              bottom: 0,
              right: 0,
              child: Image.asset('assets/images/bottom.png'),
            ),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    reverse: true,
                    controller: _scrollController,
                    child: Column(
                      children: [
                        Text(
                          _authMode == AuthMode.login ? 'Login' : 'Sign Up',
                          style: TextStyle(
                              color: isDarkMode
                                  ? kContentColorDarkTheme
                                  : kContentColorLightTheme,
                              fontFamily: 'Rock3D',
                              fontSize: 50,
                              fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: kDefaultPadding),
                        SizedBox(
                          width: deviceWidth * 0.8,
                          child: Image.asset(
                            _authMode == AuthMode.login
                                ? 'assets/images/login.png'
                                : 'assets/images/signup.png',
                          ),
                        ),
                        const SizedBox(height: kDefaultPadding),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              if (_authMode == AuthMode.signUp)
                                Container(
                                  width: deviceWidth * 0.8,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: deviceHeight * 0.03),
                                  decoration: BoxDecoration(
                                      color: kPrimaryColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(32)),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 2) {
                                        return 'T??n kh??ng th??? ????? tr???ng.';
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: _userNameController,
                                    decoration: const InputDecoration(
                                        icon: Icon(Icons.person),
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        hintText: "T??n",
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none),
                                  ),
                                ),
                              const SizedBox(height: kDefaultPadding),
                              Container(
                                width: deviceWidth * 0.8,
                                padding: EdgeInsets.symmetric(
                                    horizontal: deviceHeight * 0.03),
                                decoration: BoxDecoration(
                                    color: kPrimaryColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(32)),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Vui l??ng cung c???p ?????a ch??? email.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.email),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      hintText: "Email",
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none),
                                ),
                              ),
                              const SizedBox(height: kDefaultPadding),
                              Container(
                                width: deviceWidth * 0.8,
                                padding: EdgeInsets.symmetric(
                                    horizontal: deviceHeight * 0.03),
                                decoration: BoxDecoration(
                                    color: kPrimaryColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(32)),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 5) {
                                      return 'Vui l??ng nh???p m???t kh???u nhi???u h??n 5 k?? t???.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: _passwordController,
                                  obscureText: _isObscure,
                                  decoration: InputDecoration(
                                      icon: const Icon(Icons.lock),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isObscure
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isObscure = !_isObscure;
                                          });
                                        },
                                      ),
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      hintText: "M???t kh???u",
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none),
                                ),
                              ),
                              const SizedBox(height: kDefaultPadding),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          child: Text(
                            _authMode == AuthMode.login
                                ? '????ng nh???p'
                                : '????ng k??',
                          ),
                          style: ElevatedButton.styleFrom(
                            fixedSize:
                                Size(deviceWidth * 0.8, deviceHeight * 0.055),
                            primary: const Color(0xFF395B65),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                          ),
                          onPressed: () {
                            submit();
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_authMode == AuthMode.login
                                ? 'B???n ch??a c?? t??i kho???n? '
                                : 'B???n ???? c?? t??i kho???n? '),
                            TextButton(
                              onPressed: _switchAuthMode,
                              child: Text(
                                _authMode == AuthMode.login
                                    ? '????ng k??'
                                    : '????ng nh???p',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: kDefaultPadding * 2),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
