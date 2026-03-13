import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSentState extends AuthState {
  final String verificationId;
  const OtpSentState(this.verificationId);

  @override
  List<Object> get props => [verificationId];
}

class AuthenticatedState extends AuthState {
  final UserEntity user;
  const AuthenticatedState(this.user);

  @override
  List<Object> get props => [user];
}

class UnauthenticatedState extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
