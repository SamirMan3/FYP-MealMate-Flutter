import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  late String _accessToken;
  late String _username;
  late String _email;

  String get accessToken => _accessToken;
  String get username => _username;
  String get email => _email;

  set accessToken(String token) {
    _accessToken = token;
    notifyListeners();
  }
  set username(String token) {
    _username = token;
    notifyListeners();
  }
  set email(String token) {
    _email = token;
    notifyListeners();
  }
}
// // Simulate login success and get access token
//             String accessToken = 'YOUR_ACCESS_TOKEN_HERE';

//             // Set access token in the context
//             Provider.of<AuthProvider>(context, listen: false).accessToken = accessToken;
