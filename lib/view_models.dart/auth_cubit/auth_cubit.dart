import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/users_data_model.dart';
import 'package:flutter_ecommerce_app/services/auth_service.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart';
import 'package:flutter_ecommerce_app/utils/api_path.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthServiceImpl authService = AuthServiceImpl();
  final FirestoreServices firestoreServices = FirestoreServices.instance;

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    emit(AuthLoading());

    try {
      final result = await authService.loginWithEmailAndPassword(
        email,
        password,
      );

      if (result == true) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure("Login failed"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String userName,
  ) async {
    emit(AuthLoading());

    try {
      final result = await authService.registerWithEmailAndPassword(
        email,
        password,
      );

      final currentUser = authService.getCurrentUser();
      await firestoreServices.setData(
        path: ApiPath.users(currentUser!.uid),
        data: UsersDataModel(
          id: currentUser.uid,
          userName: userName,
          email: email,
          createdAt: DateTime.now().toIso8601String(),
        ).toMap(),
      );

      if (result == true) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure("Registration failed"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> authenticateWithGoogle() async {
    emit(AuthenticateWithGoogleLoading());

    try {
      final result = await authService.authenticateWithGoogle();

      if (result == true) {
        emit(AuthenticateWithGoogleSuccess());
      } else {
        emit(
          AuthenticateWithGoogleFailure(
            "Google authentication failed or cancelled",
          ),
        );
      }
    } catch (e) {
      emit(AuthenticateWithGoogleFailure(e.toString()));
    }
  }

  Future<void> authenticateWithFacebook() async {
    emit(AuthenticateWithFacebookLoading());

    try {
      final result = await authService.authenticateWithFacebook();
      if (result == true) {
        emit(AuthenticateWithFacebookSuccess());
      } else {
        emit(
          AuthenticateWithFacebookFailure(
            "Facebook authentication failed or cancelled",
          ),
        );
      }
    } catch (e) {
      emit(AuthenticateWithFacebookFailure(e.toString()));
    }
  }

  void checkAuth() {
    final user = authService.getCurrentUser();
    if (user != null) {
      emit(AuthSuccess());
    }
  }

  Future<void> logout() async {
    emit(LogoutLoading());

    try {
      await authService.logout();
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(e.toString()));
    }
  }
}
