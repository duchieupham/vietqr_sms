import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietqr_sms/commons/enum/enum.dart';
import 'package:vietqr_sms/commons/utils/string_utils.dart';
import 'package:vietqr_sms/models/response_message_dto.dart';
import 'package:vietqr_sms/screens/register/events/register_event.dart';
import 'package:vietqr_sms/screens/register/repositories/register_repository.dart';
import 'package:vietqr_sms/screens/register/states/register_state.dart';
import 'package:vietqr_sms/themes/constant.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitialState()) {
    on<RegisterEventSubmit>(_register);
    on<RegisterEventSentOTP>(_sentOtp);
    // on<RegisterEventReSentOTP>(_reSentOtp);
  }

  void _register(RegisterEvent event, Emitter emit) async {
    try {
      if (event is RegisterEventSubmit) {
        emit(RegisterLoadingState());
        ResponseMessageDTO responseMessageDTO =
            await registerRepository.register(event.dto);
        if (responseMessageDTO.status == Constant.RESPONSE_STATUS_SUCCESS) {
          emit(RegisterSuccessState());
        } else {
          String msg = StringUtils.getErrorMessage(responseMessageDTO.message);
          emit(RegisterFailedState(msg: msg));
        }
      }
    } catch (e) {
      emit(const RegisterFailedState(
          msg: 'Không thể đăng ký. Vui lòng kiểm tra lại kết nối.'));
    }
  }

  void _sentOtp(RegisterEvent event, Emitter<RegisterState> emit) {
    try {
      if (event is RegisterEventSentOTP) {
        emit(RegisterSentOTPLoadingState());
        if (event.typeOTP == TypeOTP.SUCCESS) {
          emit(RegisterSentOTPSuccessState());
        } else if (event.typeOTP == TypeOTP.FAILED) {
          emit(const RegisterSentOTPFailedState(
              msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.'));
        }
      }
    } catch (e) {
      emit(const RegisterSentOTPFailedState(
          msg: 'Có lỗi xảy ra. Vui lòng kiểm tra lại kết nối.'));
    }
  }
}

const RegisterRepository registerRepository = RegisterRepository();
