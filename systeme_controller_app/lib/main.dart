import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systeme_controller_app/services/auth/bloc/auth_bloc.dart';
import 'package:systeme_controller_app/services/auth/bloc/auth_event.dart';
import 'package:systeme_controller_app/services/auth/bloc/auth_state.dart';
import 'package:systeme_controller_app/services/auth/firebase_auth_provider.dart';
import 'package:systeme_controller_app/views/main_views/main_view.dart';
import 'package:systeme_controller_app/views/user_views/login_view.dart';
import 'package:systeme_controller_app/views/user_views/sign_in_view.dart';
import 'package:systeme_controller_app/views/user_views/verification_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App controller Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: ((context) => AuthBloc(FirebaseAuthProvider())),
        child: const ViewsController(),
      ),
    );
  }
}

class ViewsController extends StatelessWidget {
  const ViewsController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthStateLoggedOut) {
        return LoginView();
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else if (state is AuthStateLoggedIn) {
        return MainView();
      } else if (state is AuthStateNeedsVerification) {
        return VerificationView();
      } else {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}
