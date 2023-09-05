import 'package:equatable/equatable.dart';
import 'package:vietqr_sms/commons/enum/enum.dart';

class DashBoardState extends Equatable {
  final BlocStatus status;
  final String? msg;
  final DashBoardType request;
  final TokenType typeToken;

  const DashBoardState({
    this.status = BlocStatus.NONE,
    this.msg,
    this.request = DashBoardType.NONE,
    this.typeToken = TokenType.NONE,
  });

  DashBoardState copyWith({
    BlocStatus? status,
    String? msg,
    DashBoardType? request,
    TokenType? typeToken,
  }) {
    return DashBoardState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      request: request ?? this.request,
      typeToken: typeToken ?? this.typeToken,
    );
  }

  @override
  List<Object?> get props => [status, msg, request, typeToken];
}
