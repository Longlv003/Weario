import 'package:weario/models/account_model.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final AccountModel accountModel;

  RegisterSuccess(this.accountModel);
}

class RegisterFailure extends RegisterState {
  final String message;

  RegisterFailure(this.message);
}
