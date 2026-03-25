import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../services/local_storage_service.dart';

class AuthProvider {
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future register(String email, String password) async {
    var users = await LocalStorageService.getData('users') ?? [];

    users.add({
      'email': email,
      'password': hashPassword(password),
    });

    await LocalStorageService.saveData('users', users);
  }

  Future<bool> login(String email, String password) async {
    var users = await LocalStorageService.getData('users') ?? [];

    String hashed = hashPassword(password);

    for (var user in users) {
      if (user['email'] == email && user['password'] == hashed) {
        return true;
      }
    }
    return false;
  }
}