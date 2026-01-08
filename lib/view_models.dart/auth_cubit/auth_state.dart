part of 'auth_cubit.dart';

class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {}

final class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

final class LogoutLoading extends AuthState {}

final class LogoutSuccess extends AuthState {}

final class LogoutFailure extends AuthState {
  final String message;
  LogoutFailure(this.message);
}

final class AuthenticateWithGoogleLoading extends AuthState {}

final class AuthenticateWithGoogleSuccess extends AuthState {}

final class AuthenticateWithGoogleFailure extends AuthState {
  final String message;
  AuthenticateWithGoogleFailure(this.message);
}

final class AuthenticateWithFacebookLoading extends AuthState {}

final class AuthenticateWithFacebookSuccess extends AuthState {}

final class AuthenticateWithFacebookFailure extends AuthState {
  final String message;
  AuthenticateWithFacebookFailure(this.message);
}

// User Data States
final class UserDataLoaded extends AuthState {
  final UsersDataModel userData;
  UserDataLoaded(this.userData);
}

final class UserDataLoading extends AuthState {}

final class UserDataFailure extends AuthState {
  final String message;
  UserDataFailure(this.message);
}

// Update Profile States
final class UpdateProfileLoading extends AuthState {}

final class UpdateProfileSuccess extends AuthState {
  final UsersDataModel userData;
  UpdateProfileSuccess(this.userData);
}

final class UpdateProfileFailure extends AuthState {
  final String message;
  UpdateProfileFailure(this.message);
}
