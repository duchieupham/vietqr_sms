import 'package:equatable/equatable.dart';
import 'package:vietqr_sms/commons/enum/enum.dart';
import 'package:vietqr_sms/models/info_user_dto.dart';

class LoginState extends Equatable {
  final InfoUserDTO? infoUserDTO;
  final BlocStatus? status;
  final LoginType? request;
  final bool isToast;
  final String? msg;
  final String? phone;

  const LoginState({
    this.infoUserDTO,
    this.msg,
    this.phone,
    this.status = BlocStatus.NONE,
    this.request = LoginType.NONE,
    this.isToast = false,
  });

  LoginState copyWith(
      {BlocStatus? status,
      LoginType? request,
      String? msg,
      bool? isToast,
      InfoUserDTO? infoUserDTO,
      String? phone}) {
    return LoginState(
      status: status ?? this.status,
      request: request ?? this.request,
      isToast: isToast ?? this.isToast,
      msg: msg ?? this.msg,
      infoUserDTO: infoUserDTO ?? this.infoUserDTO,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props =>
      [infoUserDTO, status, request, msg, isToast, phone];
}
