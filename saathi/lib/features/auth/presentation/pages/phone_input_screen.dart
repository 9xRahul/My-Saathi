import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class PhoneInputScreen extends StatefulWidget {
  final bool isLogin;
  
  const PhoneInputScreen({super.key, required this.isLogin});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    final phone = _phoneController.text.trim();
    if (phone.isNotEmpty) {
      context.read<AuthBloc>().add(SendOtpEvent(phone));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isLogin ? 'Login with OTP' : 'Sign Up'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your mobile number',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Login or sign up with your phone number.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
                hintText: '+1 234 567 8900',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _sendOtp,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
