import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<OtpCodeSentEvent>(_onOtpCodeSent);
    on<OtpVerificationFailedEvent>(_onOtpVerificationFailed);
    on<SetupPasswordEvent>(_onSetupPassword);
    on<LoginWithPasswordEvent>(_onLoginWithPassword);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.verifyPhone(
      phoneNumber: event.phoneNumber,
      codeSent: (verificationId) {
        add(OtpCodeSentEvent(verificationId));
      },
      verificationFailed: (failure) {
        add(OtpVerificationFailedEvent(failure.message));
      },
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) {}, // Success is handled via codeSent callback triggering OtpCodeSentEvent
    );
  }

  void _onOtpCodeSent(OtpCodeSentEvent event, Emitter<AuthState> emit) {
    emit(OtpSentState(event.verificationId));
  }

  void _onOtpVerificationFailed(OtpVerificationFailedEvent event, Emitter<AuthState> emit) {
    emit(AuthError(event.message));
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.verifyOtp(
      verificationId: event.verificationId,
      smsCode: event.smsCode,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthenticatedState(user)),
    );
  }

  Future<void> _onSetupPassword(SetupPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.setupPassword(password: event.password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => add(CheckAuthStatusEvent()), // Re-check status to emit AuthenticatedState
    );
  }

  Future<void> _onLoginWithPassword(LoginWithPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.loginWithPassword(
      phoneNumber: event.phoneNumber,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthenticatedState(user)),
    );
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(UnauthenticatedState()),
      (user) => emit(AuthenticatedState(user)),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository.logout();
    emit(UnauthenticatedState());
  }
}
