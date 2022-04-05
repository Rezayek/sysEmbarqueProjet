import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systeme_controller_app/services/auth/auth_exceptions.dart';
import 'package:systeme_controller_app/services/auth/bloc/auth_bloc.dart';
import 'package:systeme_controller_app/services/auth/bloc/auth_event.dart';
import 'package:systeme_controller_app/services/auth/bloc/auth_state.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundException) {
          } else if (state.exception is WrongPasswordException) {
          } else if (state.exception is GenericAuthException) {}
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4)),
          child: Center(
              child: SizedBox(
            height: 300,
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _emailController,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: false,
                  decoration: const InputDecoration(hintText: 'enter email'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _passwordController,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: false,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'enter password'),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 80,
                  width: 220,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(AuthEventLogIn(
                                _emailController.text,
                                _passwordController.text));
                          },
                          child: const Text('Login')),
                      ElevatedButton(
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventShouldRegister());
                            log('event sended');
                          },
                          child: const Text('Register')),
                    ],
                  ),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
