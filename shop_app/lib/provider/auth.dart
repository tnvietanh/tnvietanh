import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _token, _userId;
  DateTime? _expiryDate;

  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get userId => _userId;
  DateTime? get expiryDate => _expiryDate;
  void _auth(String? email, String? password, String urlSegment) async {
    _isLoading = true;
    notifyListeners();
    try {
      const _apiKey = 'AIzaSyDVyU_jjujCX5Mn_KVh29_w-eN0ZVCeiSg';
      final _url =
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=$_apiKey';
      final body = json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      );
      final response = await http.post(Uri.parse(_url), body: body);
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    return _auth(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    return _auth(email, password, 'verifyPassword');
  }
}
