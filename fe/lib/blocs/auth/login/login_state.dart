import 'package:weario/models/account/account_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final AccountModel account;

  LoginSuccess(this.account);
}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);
}
