import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_state.dart';
import 'status_step.dart';
import 'bio_step.dart';
import 'phone_auth_step.dart';
import 'upload_photos_step.dart';

class OnboardingWrapper extends StatelessWidget {
  const OnboardingWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
            );
          }
          if (state.isProfileComplete) {
            // Navigate to Home
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Home Screen')))),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: state.currentStep / 4,
                  backgroundColor: Colors.white12,
                  color: Colors.deepOrange,
                  minHeight: 4,
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: _getStepWidget(state.currentStep),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getStepWidget(int step) {
    switch (step) {
      case 1:
        return const StatusStep(key: ValueKey(1));
      case 2:
        return const BioStep(key: ValueKey(2));
      case 3:
        return const PhoneAuthStep(key: ValueKey(3));
      case 4:
        return const UploadPhotosStep(key: ValueKey(4));
      default:
        return const StatusStep(key: ValueKey(1));
    }
  }
}
