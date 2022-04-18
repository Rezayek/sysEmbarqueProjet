import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:systeme_controller_app/services/auth/auth_provider.dart';
import 'package:systeme_controller_app/services/auth/bloc/auth_event.dart';
import 'package:systeme_controller_app/services/auth/bloc/auth_state.dart';
import 'package:systeme_controller_app/services/auth/user_data_firebase/firebase_user_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUnInitialized()) {
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        emit(state);
      },
    );
    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(const AuthStateRegistering(exception: null));
        log('emited');
      },
    );

    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      final access = event.access;
      final accessFan = event.accessFan;
      FirebaseUserStorage userStorage = FirebaseUserStorage();

      try {
        final user =
            await provider.createUser(email: email, password: password);
        await userStorage.createUserData(
            userOwnId: user.id,
            userOwnEmail: email,
            userHasLightsAccess: access,
            userHasFanAccess: accessFan);
        emit(const AuthStateNeedsVerification());
        await provider.sendEmailVerification();
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e));
      }
    });

    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut(exception: null));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification());
        } else {
          emit(AuthStateLoggedIn(user: user));
        }
      },
    );

    on<AuthEventLogIn>(
      (event, emit) async {
        final email = event.email;
        final password = event.passwored;
        try {
          final user = await provider.logIn(email: email, password: password);
          if (!user.isEmailVerified) {
            emit(const AuthStateNeedsVerification());
          } else {
            emit(AuthStateLoggedIn(user: user));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e));
        }
      },
    );

    on<AuthEventLogOut>(
      ((event, emit) async {
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut(exception: null));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e));
        }
      }),
    );
  }
}
