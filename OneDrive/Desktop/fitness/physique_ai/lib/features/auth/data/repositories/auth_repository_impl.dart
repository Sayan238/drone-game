import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Box _settingsBox = Hive.box('app_settings');

  @override
  Future<UserEntity?> login(String email, String password) async {
    // Mock local auth - in production, use Firebase Auth
    await Future.delayed(const Duration(milliseconds: 800));

    final userData = _settingsBox.get('user_data');
    if (userData != null) {
      final user = UserModel.fromJson(jsonDecode(userData));
      if (user.email == email) {
        final loggedInUser = UserModel(
          id: user.id,
          email: user.email,
          name: user.name,
          isLoggedIn: true,
        );
        await _settingsBox.put('user_data', jsonEncode(loggedInUser.toJson()));
        return loggedInUser;
      }
    }

    // Create a new user if not found (for demo purposes)
    final newUser = UserModel(
      id: const Uuid().v4(),
      email: email,
      name: email.split('@').first,
      isLoggedIn: true,
    );
    await _settingsBox.put('user_data', jsonEncode(newUser.toJson()));
    return newUser;
  }

  @override
  Future<UserEntity?> signUp(
      String email, String password, String name) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final newUser = UserModel(
      id: const Uuid().v4(),
      email: email,
      name: name,
      isLoggedIn: true,
    );
    await _settingsBox.put('user_data', jsonEncode(newUser.toJson()));
    return newUser;
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    // Mock Google sign-in - in production, use google_sign_in + firebase_auth
    await Future.delayed(const Duration(milliseconds: 800));

    final newUser = UserModel(
      id: const Uuid().v4(),
      email: 'user@gmail.com',
      name: 'Google User',
      isLoggedIn: true,
    );
    await _settingsBox.put('user_data', jsonEncode(newUser.toJson()));
    return newUser;
  }

  @override
  Future<void> logout() async {
    final userData = _settingsBox.get('user_data');
    if (userData != null) {
      final user = UserModel.fromJson(jsonDecode(userData));
      final loggedOutUser = UserModel(
        id: user.id,
        email: user.email,
        name: user.name,
        isLoggedIn: false,
      );
      await _settingsBox.put(
          'user_data', jsonEncode(loggedOutUser.toJson()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final userData = _settingsBox.get('user_data');
    if (userData != null) {
      final user = UserModel.fromJson(jsonDecode(userData));
      return user.isLoggedIn;
    }
    return false;
  }
}
