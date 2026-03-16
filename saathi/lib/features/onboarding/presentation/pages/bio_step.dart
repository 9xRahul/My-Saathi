import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';

class BioStep extends StatefulWidget {
  const BioStep({super.key});

  @override
  State<BioStep> createState() => _BioStepState();
}

class _BioStepState extends State<BioStep> {
  final TextEditingController _bioController = TextEditingController();
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _bioController.addListener(() {
      setState(() {
        _charCount = _bioController.text.length;
      });
    });
    final state = context.read<OnboardingBloc>().state;
    if (state.bio != null) {
      _bioController.text = state.bio!;
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _save() {
    if (_charCount >= 50) {
      context.read<OnboardingBloc>().add(UpdateBioEvent(_bioController.text));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least 50 characters')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Describe yourself',
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
              // Usually skipping might mean proceeding without saving, or just saving empty
              context.read<OnboardingBloc>().add(const UpdateBioEvent(''));
            },
            child: const Text(
              'SKIP',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _bioController,
                  maxLines: 8,
                  maxLength: 500, // Reasonable max length limit
                  decoration: const InputDecoration(
                    hintText: 'Describe yourself. What do you currently do? What is quirky about you? What makes you smile? ...',
                    border: InputBorder.none,
                    counterText: '', // Hide default counter
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Minimum 50 characters / \$_charCount',
                  style: TextStyle(
                    color: _charCount < 50 ? Colors.grey : Colors.blue,
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _charCount >= 50 ? _save : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  disabledBackgroundColor: Colors.deepOrange.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'SAVE',
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
