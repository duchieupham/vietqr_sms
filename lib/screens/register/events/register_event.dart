import 'package:equatable/equatable.dart';
import 'package:vietqr_sms/commons/enum/enum.dart';
import 'package:vietqr_sms/models/account_login_dto.dart';

class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterEventSubmit extends RegisterEvent {
  final AccountLoginDTO dto;

  const RegisterEventSubmit({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class RegisterEventSentOTP extends RegisterEvent {
  final TypeOTP typeOTP;

  const RegisterEventSentOTP({required this.typeOTP});

  @override
  List<Object?> get props => [typeOTP];
}

class RegisterEventReSentOTP extends RegisterEvent {
  final TypeOTP typeOTP;

  const RegisterEventReSentOTP({required this.typeOTP});

  @override
  List<Object?> get props => [typeOTP];
}
