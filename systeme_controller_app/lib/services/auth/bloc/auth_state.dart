import 'package:systeme_controller_app/services/auth/auth_user.dart';

abstract class AuthState {
  const AuthState();
}

class AuthStateUnInitialized extends AuthState {
  const AuthStateUnInitialized() : super();
}

class AuthStateInitialized extends AuthState {
  const AuthStateInitialized() : super();
}

class AuthStateRegistering extends AuthState {
    final Exception? exception;
  const AuthStateRegistering({required this.exception}) : super();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user}) : super();
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification() : super();
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut({required this.exception}) : super();
}


