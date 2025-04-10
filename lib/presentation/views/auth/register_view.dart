import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/core/utils/routes.dart';
import 'package:to_do/presentation/view_models/auth_view_model.dart';
import 'package:to_do/widgets/custom_text_field.dart';
import 'package:to_do/widgets/custom_button.dart';

class RegisterView extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              const Center(child: Text('Sign Up', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
              const SizedBox(height: 30),
              CustomTextField(controller: nameController, hintText: 'Name...'),
              const SizedBox(height: 12),
              CustomTextField(controller: emailController, hintText: 'Email...'),
              const SizedBox(height: 12),
              CustomTextField(controller: passwordController, hintText: 'Password...', obscureText: true),
              const SizedBox(height: 50),
              CustomButton(
                label: 'Register',
                onPressed: () async {
                  try {
                    await authViewModel.register(emailController.text, passwordController.text, nameController.text);
                    if (authViewModel.isAuthenticated) {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed: $e')));
                  }
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
