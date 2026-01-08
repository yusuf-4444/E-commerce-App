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

  UsersDataModel? currentUserData;

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    emit(AuthLoading());

    try {
      final result = await authService.loginWithEmailAndPassword(
        email,
        password,
      );

      if (result == true) {
        await loadUserData();
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
      if (currentUser == null) {
        emit(AuthFailure("Registration failed"));
        return;
      }

      final userData = UsersDataModel(
        id: currentUser.uid,
        userName: userName,
        email: email,
        createdAt: DateTime.now().toIso8601String(),
      );

      await firestoreServices.setData(
        path: ApiPath.users(currentUser.uid),
        data: userData.toMap(),
      );

      if (result == true) {
        currentUserData = userData;
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
        final currentUser = authService.getCurrentUser();
        if (currentUser != null) {
          // Check if user data exists
          try {
            await loadUserData();
          } catch (e) {
            // Create user data if doesn't exist
            final userData = UsersDataModel(
              id: currentUser.uid,
              userName: currentUser.displayName ?? "User",
              email: currentUser.email ?? "",
              createdAt: DateTime.now().toIso8601String(),
            );
            await firestoreServices.setData(
              path: ApiPath.users(currentUser.uid),
              data: userData.toMap(),
            );
            currentUserData = userData;
          }
        }
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
        final currentUser = authService.getCurrentUser();
        if (currentUser != null) {
          // Check if user data exists
          try {
            await loadUserData();
          } catch (e) {
            // Create user data if doesn't exist
            final userData = UsersDataModel(
              id: currentUser.uid,
              userName: currentUser.displayName ?? "User",
              email: currentUser.email ?? "",
              createdAt: DateTime.now().toIso8601String(),
            );
            await firestoreServices.setData(
              path: ApiPath.users(currentUser.uid),
              data: userData.toMap(),
            );
            currentUserData = userData;
          }
        }
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
      loadUserData();
      emit(AuthSuccess());
    }
  }

  Future<void> loadUserData() async {
    try {
      final currentUser = authService.getCurrentUser();
      if (currentUser == null) return;

      final userData = await firestoreServices.getDocument(
        path: ApiPath.users(currentUser.uid),
        builder: (data, documentId) => UsersDataModel.fromMap(data),
      );
      currentUserData = userData;
      emit(UserDataLoaded(userData));
    } catch (e) {
      // User data doesn't exist yet
      currentUserData = null;
    }
  }

  Future<void> logout() async {
    emit(LogoutLoading());

    try {
      await authService.logout();
      currentUserData = null;
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(e.toString()));
    }
  }

  Future<void> updateUserProfile({String? userName, String? email}) async {
    emit(UpdateProfileLoading());

    try {
      final currentUser = authService.getCurrentUser();
      if (currentUser == null) {
        emit(UpdateProfileFailure("User not authenticated"));
        return;
      }

      if (currentUserData == null) {
        await loadUserData();
      }

      if (currentUserData == null) {
        emit(UpdateProfileFailure("User data not found"));
        return;
      }

      final updatedData = UsersDataModel(
        id: currentUserData!.id,
        userName: userName ?? currentUserData!.userName,
        email: email ?? currentUserData!.email,
        createdAt: currentUserData!.createdAt,
      );

      await firestoreServices.setData(
        path: ApiPath.users(currentUser.uid),
        data: updatedData.toMap(),
      );

      currentUserData = updatedData;
      emit(UpdateProfileSuccess(updatedData));
    } catch (e) {
      emit(UpdateProfileFailure(e.toString()));
    }
  }
}
