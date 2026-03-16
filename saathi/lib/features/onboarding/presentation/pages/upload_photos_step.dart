import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';

class UploadPhotosStep extends StatefulWidget {
  const UploadPhotosStep({super.key});

  @override
  State<UploadPhotosStep> createState() => _UploadPhotosStepState();
}

class _UploadPhotosStepState extends State<UploadPhotosStep> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      // Assuming we only upload one primary photo for now based on the BLoC structure
      if (!mounted) return;
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthenticatedState) {
        context.read<OnboardingBloc>().add(
          UploadProfilePictureEvent(
            file: _imageFile!,
            userId: authState.user.id,
          ),
        );
      }
    }
  }

  void _showUploadOptions() {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48), // Balance for centering
                    const Text(
                      'Upload Photos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _UploadOptionTile(
                  icon: Icons.image_outlined,
                  title: 'From Gallery',
                  subtitle: "It's fast and easy!",
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const Divider(),
                _UploadOptionTile(
                  icon: Icons.facebook,
                  title: 'From Facebook',
                  onTap: () {
                    Navigator.pop(ctx);
                    // Implement facebook photo picking or fallback to gallery
                  },
                ),
                const Divider(),
                _UploadOptionTile(
                  icon: Icons.camera_alt_outlined,
                  title: 'Take a selfie',
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.orange[800]),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Upload photos to show up in matches',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submit() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthenticatedState) {
      context.read<OnboardingBloc>().add(SubmitProfileEvent(authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Upload your photos',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // SKIP action
              _submit();
            },
            child: const Text('SKIP', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  children: List.generate(4, (index) {
                    return GestureDetector(
                      onTap: _showUploadOptions,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: index == 0 && _imageFile != null
                            ? ClipOval(
                                child: Image.file(_imageFile!, fit: BoxFit.cover),
                              )
                            : Icon(
                                Icons.add,
                                size: 48,
                                color: Colors.grey[500],
                              ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.orange[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lightbulb, color: Colors.orange[800]),
                    const SizedBox(width: 8),
                    const Text(
                      'Upload photos to show up in matches',
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'SUBMIT',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _UploadOptionTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.grey[600]),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle!, style: const TextStyle(color: Colors.blue, fontSize: 12)) : null,
      onTap: onTap,
    );
  }
}
