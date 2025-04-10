import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/presentation/view_models/auth_view_model.dart';
import 'package:to_do/presentation/views/auth/login_view.dart';
import 'package:to_do/presentation/views/home/home_view.dart';

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    if (authViewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authViewModel.isAuthenticated) {
      return const HomeView();
    }

    return LoginView();
  }
}
