import 'package:equatable/equatable.dart';

class DashBoardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ValidTokenEvent extends DashBoardEvent {}

class TokenEventLogout extends DashBoardEvent {}
