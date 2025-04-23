import 'package:flutter/material.dart';

class UserViewmodel extends ChangeNotifier {
  final String _username;
  String get username => _username;

  UserViewmodel({required String username}) : _username = username;
}
