import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'welcome_screen.dart';
import 'otp_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.pinkAccent),
              // child: Lottie.asset('assets/animations/loader.json'), // Requires asset to be added
            ),
          );
        } else if (state is OtpSentState) {
          return OtpScreen(verificationId: state.verificationId);
        } else if (state is AuthenticatedState) {
          // If profile is not complete, go to Onboarding. Else go to Home.
          // For now, return a placeholder for OnboardingGate
          return const Scaffold(body: Center(child: Text('Authenticated - Go to Onboarding or Home')));
        } else {
          // Unauthenticated or Initial or Error
          return const WelcomeScreen();
        }
      },
    );
  }
}
