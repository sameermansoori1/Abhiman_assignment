import 'package:abhiman_assignment/features/auth/domain/entities/app_user.dart';

abstract class AuthState {}

//intital
class AuthInitial extends AuthState {}

//loading..
class AuthLoading extends AuthState {}

//authenticated
class Authenticated extends AuthState {
  final AppUser user;
  Authenticated(this.user);
}

//unauthenticated state
class Unauthenticated extends AuthState {}

//errors..
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
