import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'local_storage_service.dart';

class AuthService {
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future register(String email, String password) async {
    final users = await LocalStorageService.getData('users') ?? [];

    users.add({
      'email': email,
      'password': hashPassword(password),
    });

    await LocalStorageService.saveData('users', users);
  }

  Future<bool> login(String email, String password) async {
    final users = await LocalStorageService.getData('users') ?? [];

    String hashed = hashPassword(password);

    for (var u in users) {
      if (u['email'] == email && u['password'] == hashed) {
        return true;
      }
    }
    return false;
  }
}