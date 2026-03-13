import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';

class BasicInfoStep extends StatefulWidget {
  const BasicInfoStep({super.key});

  @override
  State<BasicInfoStep> createState() => _BasicInfoStepState();
}

class _BasicInfoStepState extends State<BasicInfoStep> {
  final _nameController = TextEditingController();
  String _selectedGender = 'Male';
  DateTime _dob = DateTime(2000);

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingBloc>().state;
    if (state.displayName != null) _nameController.text = state.displayName!;
    if (state.gender != null) _selectedGender = state.gender!;
    if (state.dob != null) _dob = state.dob!;
  }

  void _submit() {
    if (_nameController.text.isNotEmpty) {
      context.read<OnboardingBloc>().add(UpdateBasicInfoEvent(
            displayName: _nameController.text,
            gender: _selectedGender,
            dob: _dob,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'About You',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Display Name'),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: const InputDecoration(labelText: 'Gender'),
            items: ['Male', 'Female', 'Non-Binary', 'Other']
                .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                .toList(),
            onChanged: (val) => setState(() => _selectedGender = val!),
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _dob,
                firstDate: DateTime(1900),
                lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
              );
              if (date != null) setState(() => _dob = date);
            },
            child: InputDecorator(
              decoration: const InputDecoration(labelText: 'Date of Birth'),
              child: Text('\${_dob.year}-\${_dob.month}-\${_dob.day}'),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
