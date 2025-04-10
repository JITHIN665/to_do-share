// presentation/views/login_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/core/utils/routes.dart';
import 'package:to_do/presentation/view_models/auth_view_model.dart';
import 'package:to_do/widgets/custom_text_field.dart';
import 'package:to_do/widgets/custom_button.dart';

class LoginView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              const Center(child: Text('Sign In', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
              const SizedBox(height: 20),
              CustomTextField(controller: emailController, hintText: 'Email...'),
              const SizedBox(height: 12),
              CustomTextField(controller: passwordController, hintText: 'Password...', obscureText: true),
              const SizedBox(height: 100),
              CustomButton(
                label: 'Sign In',
                onPressed: () async {
                  try {
                    await authViewModel.signIn(emailController.text, passwordController.text);
                    if (authViewModel.isAuthenticated) {
                      Navigator.pushReplacementNamed(context, AppRoutes.home);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: $e')));
                  }
                },
              ),
              const SizedBox(height: 16),
              TextButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.register), child: const Text("Don't have an account? SignUp")),
            ],
          ),
        ),
      ),
    );
  }
}
