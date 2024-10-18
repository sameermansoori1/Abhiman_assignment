import 'package:abhiman_assignment/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> signupWithEmailPassword(
      String name, String email, String password);
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
}
