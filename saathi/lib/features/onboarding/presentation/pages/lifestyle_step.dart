import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';

class LifestyleStep extends StatefulWidget {
  const LifestyleStep({super.key});

  @override
  State<LifestyleStep> createState() => _LifestyleStepState();
}

class _LifestyleStepState extends State<LifestyleStep> {
  final _interestsController = TextEditingController();
  final _hobbiesController = TextEditingController();
  String _drinking = 'Occasionally';

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingBloc>().state;
    if (state.interests.isNotEmpty) {
      _interestsController.text = state.interests.join(', ');
    }
    if (state.hobbies.isNotEmpty) {
      _hobbiesController.text = state.hobbies.join(', ');
    }
    if (state.drinking != null) _drinking = state.drinking!;
  }

  void _submit() {
    final interests = _interestsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final hobbies = _hobbiesController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    context.read<OnboardingBloc>().add(UpdateLifestyleEvent(
          interests: interests,
          hobbies: hobbies,
          drinking: _drinking,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Your Lifestyle',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _interestsController,
            decoration: const InputDecoration(
              labelText: 'Interests (comma separated)',
              hintText: 'Music, Travel, Food',
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _hobbiesController,
            decoration: const InputDecoration(
              labelText: 'Hobbies (comma separated)',
              hintText: 'Reading, Hiking, Gaming',
            ),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            initialValue: _drinking,
            decoration: const InputDecoration(labelText: 'Drinking Preference'),
            items: ['Regularly', 'Occasionally', 'Never']
                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                .toList(),
            onChanged: (val) => setState(() => _drinking = val!),
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
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
