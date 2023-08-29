import 'package:equatable/equatable.dart';
import 'package:vietqr_sms/models/account_login_dto.dart';
import 'package:vietqr_sms/models/code_login_dto.dart';
import 'package:vietqr_sms/screens/login/blocs/login_bloc.dart';

class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginEventByPhone extends LoginEvent {
  final AccountLoginDTO dto;
  final bool isToast;

  const LoginEventByPhone({required this.dto, this.isToast = false});

  @override
  List<Object?> get props => [dto];
}

class LoginEventInsertCode extends LoginEvent {
  final String code;
  final LoginBloc loginBloc;

  const LoginEventInsertCode({required this.code, required this.loginBloc});

  @override
  List<Object?> get props => [code, loginBloc];
}

class LoginEventListen extends LoginEvent {
  final String code;
  final LoginBloc loginBloc;

  const LoginEventListen({required this.code, required this.loginBloc});

  @override
  List<Object?> get props => [code, loginBloc];
}

class LoginEventReceived extends LoginEvent {
  final CodeLoginDTO dto;

  const LoginEventReceived({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class LoginEventUpdateCode extends LoginEvent {
  final String code;
  final String userId;

  const LoginEventUpdateCode({required this.code, required this.userId});

  @override
  List<Object?> get props => [code, userId];
}

class CheckExitsPhoneEvent extends LoginEvent {
  final String phone;

  const CheckExitsPhoneEvent({required this.phone});

  @override
  List<Object?> get props => [phone];
}

class GetFreeToken extends LoginEvent {}

class UpdateEvent extends LoginEvent {}
