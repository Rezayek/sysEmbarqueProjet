import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systeme_controller_app/services/auth/auth_exceptions.dart';
import 'package:systeme_controller_app/services/auth/bloc/auth_bloc.dart';
import 'package:systeme_controller_app/services/auth/bloc/auth_event.dart';
import 'package:systeme_controller_app/services/auth/bloc/auth_state.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _userEmailController;
  late final TextEditingController _userPasswordController;
  @override
  void initState() {
    _userEmailController = TextEditingController();
    _userPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _userEmailController.dispose();
    _userPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordException) {
          } else if (state.exception is EmailAlreadyInUseException) {
          } else if (state.exception is InvalidEmailException) {
          } else if (state.exception is GenericAuthException) {}
        }
      },
      child: Scaffold(
        appBar: AppBar(title: IconButton(onPressed: (){context.read<AuthBloc>().add(const AuthEventLogOut());}, icon: const Icon(Icons.arrow_back))),
        body: Container(
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4)),
          child: Center(
              child: SizedBox(
            height: 300,
            width: 250,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'register',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _userEmailController,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    decoration: const InputDecoration(hintText: 'enter email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _userPasswordController,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    obscureText: true,
                    decoration:
                        const InputDecoration(hintText: 'enter password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50,
                    width: 120,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(AuthEventRegister(
                                _userEmailController.text,
                                _userPasswordController.text));
                          }else{

                          }
                        },
                        child: const Text('register')),
                  )
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
