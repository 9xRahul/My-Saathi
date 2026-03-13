import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';

class HabitsStep extends StatefulWidget {
  const HabitsStep({super.key});

  @override
  State<HabitsStep> createState() => _HabitsStepState();
}

class _HabitsStepState extends State<HabitsStep> {
  String _smoking = 'Never';
  String _intent = 'A Relationship';
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingBloc>().state;
    if (state.smoking != null) _smoking = state.smoking!;
    if (state.intent != null) _intent = state.intent!;
    if (state.bio != null) _bioController.text = state.bio!;
  }

  void _submit() {
    context.read<OnboardingBloc>().add(UpdateHabitsIntentEvent(
          smoking: _smoking,
          intent: _intent,
          bio: _bioController.text.trim(),
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
            'Habits & Intent',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          DropdownButtonFormField<String>(
            value: _smoking,
            decoration: const InputDecoration(labelText: 'Smoking Preference'),
            items: ['Regularly', 'Occasionally', 'Never']
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (val) => setState(() => _smoking = val!),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: _intent,
            decoration: const InputDecoration(labelText: 'What are you looking for?'),
            items: ['A Relationship', 'Something Casual', 'Not Sure Yet', 'Marriage']
                .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                .toList(),
            onChanged: (val) => setState(() => _intent = val!),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _bioController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Short Bio',
              hintText: 'Tell us a bit about yourself...',
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
