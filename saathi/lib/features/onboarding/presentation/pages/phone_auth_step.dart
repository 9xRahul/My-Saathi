import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/pages/phone_input_screen.dart';
import '../../../auth/presentation/pages/otp_screen.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';

class PhoneAuthStep extends StatelessWidget {
  const PhoneAuthStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
        if (state is AuthenticatedState) {
          // Proceed to next step when authenticated
          context.read<OnboardingBloc>().add(NextStepEvent());
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.deepOrange)),
          );
        } else if (state is OtpSentState) {
          return OtpScreen(
            verificationId: state.verificationId,
            phoneNumber: state.phoneNumber,
          );
        } else {
          return const PhoneInputScreen(isLogin: false);
        }
      },
    );
  }
}
