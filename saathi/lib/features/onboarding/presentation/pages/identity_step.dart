import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class IdentityStep extends StatefulWidget {
  const IdentityStep({super.key});

  @override
  State<IdentityStep> createState() => _IdentityStepState();
}

class _IdentityStepState extends State<IdentityStep> {
  File? _profileImage;
  File? _selfieImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _takeSelfie() async {
    // Basic implementation using ImagePicker camera source for simplicity.
    // In a production app, a custom CameraPreview using the camera package would be better
    // to enforce a "Live Selfie" frame.
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    if (pickedFile != null) {
      setState(() {
        _selfieImage = File(pickedFile.path);
      });
    }
  }

  void _submit() {
    if (_profileImage == null || _selfieImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide both profile picture and selfie.')),
      );
      return;
    }

    // Usually we would verify the selfie against the profile picture here using an API.
    // For this demonstration, we will assume it's verified and proceed to upload.
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthenticatedState) {
      context.read<OnboardingBloc>().add(UploadProfilePictureEvent(
        file: _profileImage!,
        userId: authState.user.id,
      ));
      // After upload event, the bloc should handle submission or we wait for state.
      // But we can just dispatch SubmitProfileEvent.
      context.read<OnboardingBloc>().add(SubmitProfileEvent(authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.pinkAccent),
                SizedBox(height: 16),
                Text('Finalizing Profile...', style: TextStyle(color: Colors.white70)),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Verify Your Identity',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: _pickProfileImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white12,
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(Icons.add_a_photo, size: 40, color: Colors.white54)
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Profile Picture', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 32),
              
              // Selfie Verification Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _selfieImage != null ? Colors.green : Colors.pinkAccent.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    Icon(
                      _selfieImage != null ? Icons.check_circle : Icons.face,
                      color: _selfieImage != null ? Colors.green : Colors.pinkAccent,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _selfieImage != null ? 'Selfie Verified' : 'Live Selfie Verification',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Take a quick selfie to verify you are the person in the profile picture.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    if (_selfieImage == null)
                      ElevatedButton.icon(
                        onPressed: _takeSelfie,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Take Selfie'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white12,
                          foregroundColor: Colors.white,
                        ),
                      )
                  ],
                ),
              ),
              
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<OnboardingBloc>().add(PreviousStepEvent());
                      },
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Complete Profile'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
