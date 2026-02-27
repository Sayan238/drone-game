import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> login(String email, String password);
  Future<UserEntity?> signUp(String email, String password, String name);
  Future<UserEntity?> signInWithGoogle();
  Future<void> logout();
  Future<bool> isLoggedIn();
}
