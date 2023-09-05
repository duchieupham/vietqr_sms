import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_sms/commons/enum/enum.dart';
import 'package:vietqr_sms/commons/utils/log_utils.dart';
import 'package:vietqr_sms/commons/utils/string_utils.dart';
import 'package:vietqr_sms/models/response_message_dto.dart';
import 'package:vietqr_sms/screens/dashboard/events/dashboard_event.dart';
import 'package:vietqr_sms/screens/dashboard/repos/dashboard_api.dart';
import 'package:vietqr_sms/screens/dashboard/states/dashboard_state.dart';
import 'package:vietqr_sms/themes/constant.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState> {
  DashBoardBloc() : super(const DashBoardState()) {
    on<ValidTokenEvent>(_checkValidToken);
    on<TokenEventLogout>(_logout);
  }

  DashboardApi api = const DashboardApi();

  void _checkValidToken(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is ValidTokenEvent) {
        emit(state.copyWith(
            status: BlocStatus.NONE,
            request: DashBoardType.NONE,
            typeToken: TokenType.NONE));
        ResponseMessageDTO responseMessageDTO = await api.checkValidToken();

        if (responseMessageDTO.status == Constant.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.NONE, request: DashBoardType.TOKEN));
        } else if (responseMessageDTO.status ==
            Constant.RESPONSE_STATUS_TOKEN_EXPIRED) {
          emit(state.copyWith(
              status: BlocStatus.NONE,
              request: DashBoardType.TOKEN,
              typeToken: TokenType.Expired,
              msg: 'Vui lòng đăng nhập lại ứng dụng'));
        } else {
          String msg = StringUtils.getErrorMessage(responseMessageDTO.message);
          emit(state.copyWith(
            status: BlocStatus.NONE,
            request: DashBoardType.TOKEN,
            msg: msg,
            typeToken: TokenType.MainSystem,
          ));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.NONE, request: DashBoardType.ERROR));
    }
  }

  void _logout(DashBoardEvent event, Emitter emit) async {
    try {
      if (event is TokenEventLogout) {
        emit(state.copyWith(
            status: BlocStatus.NONE, request: DashBoardType.NONE));
        bool check = await api.logout();
        TokenType type = TokenType.NONE;
        if (check) {
          type = TokenType.LogOut;
        } else {
          type = TokenType.LogOut_Failed;
        }

        emit(state.copyWith(
            status: BlocStatus.NONE,
            request: DashBoardType.TOKEN,
            typeToken: type));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.NONE,
          request: DashBoardType.TOKEN,
          typeToken: TokenType.LogOut_Failed));
    }
  }
}
