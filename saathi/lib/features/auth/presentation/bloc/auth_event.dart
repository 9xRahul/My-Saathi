import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SendOtpEvent extends AuthEvent {
  final String phoneNumber;
  const SendOtpEvent(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyOtpEvent extends AuthEvent {
  final String verificationId;
  final String smsCode;

  const VerifyOtpEvent({required this.verificationId, required this.smsCode});

  @override
  List<Object> get props => [verificationId, smsCode];
}

class OtpCodeSentEvent extends AuthEvent {
  final String verificationId;
  final String phoneNumber;
  
  const OtpCodeSentEvent(this.verificationId, this.phoneNumber);

  @override
  List<Object> get props => [verificationId, phoneNumber];
}

class OtpVerificationFailedEvent extends AuthEvent {
  final String message;
  const OtpVerificationFailedEvent(this.message);

  @override
  List<Object> get props => [message];
}

class SetupPasswordEvent extends AuthEvent {
  final String password;
  const SetupPasswordEvent(this.password);

  @override
  List<Object> get props => [password];
}

class LoginWithPasswordEvent extends AuthEvent {
  final String phoneNumber;
  final String password;

  const LoginWithPasswordEvent({required this.phoneNumber, required this.password});

  @override
  List<Object> get props => [phoneNumber, password];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
