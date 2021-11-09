import 'package:firebase_auth/firebase_auth.dart';

class AuthData {
  final User? user;
  final String message;

  AuthData({required this.user, required this.message});
}