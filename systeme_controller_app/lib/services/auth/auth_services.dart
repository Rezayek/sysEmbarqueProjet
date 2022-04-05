import 'package:systeme_controller_app/services/auth/auth_provider.dart';
import 'package:systeme_controller_app/services/auth/auth_user.dart';
import 'package:systeme_controller_app/services/auth/firebase_auth_provider.dart';

class AuthServices implements AuthProvider {
  final AuthProvider provider;
  const AuthServices(this.provider);
  factory AuthServices.firebase() => AuthServices(FirebaseAuthProvider());
  @override
  Future<AuthUser> createUser(
          {required String email, required String password}) =>
      provider.createUser(email: email, password: password);

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
