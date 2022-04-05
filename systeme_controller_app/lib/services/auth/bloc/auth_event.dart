abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String passwored;

  const AuthEventLogIn(this.email, this.passwored);
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  final bool access = false;

  AuthEventRegister(this.email,this.password);
  
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}
