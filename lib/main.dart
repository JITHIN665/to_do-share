import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/core/services/firebase_service.dart';
import 'package:to_do/core/utils/routes.dart';
import 'package:to_do/data/repositories/auth_repository.dart';
import 'package:to_do/data/repositories/task_repository.dart';
import 'package:to_do/presentation/view_models/auth_view_model.dart';
import 'package:to_do/presentation/view_models/task_view_model.dart';
// import 'package:to_do/presentation/view_models/auth_view_model.dart';
// import 'package:to_do/presentation/view_models/task_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Use Provider for simple objects that don't need to notify listeners
        Provider<AuthRepository>(create: (_) => AuthRepository()),
        Provider<TaskRepository>(create: (_) => TaskRepository()),
        
        // Use ChangeNotifierProvider for view models that extend ChangeNotifier
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(context.read<AuthRepository>())
            ..initialize(),
        ),
        
        // Use ProxyProvider to create TaskViewModel that depends on AuthViewModel
        ChangeNotifierProxyProvider<AuthViewModel, TaskViewModel>(
          create: (context) => TaskViewModel(
            context.read<TaskRepository>(),
            '', // Initial userId will be empty until auth is ready
          ),
          update: (context, authVM, taskVM) {
            // Instead of trying to set userId, we'll create a new instance if needed
            if (taskVM == null || taskVM.userId != (authVM.user?.id ?? '')) {
              return TaskViewModel(
                context.read<TaskRepository>(),
                authVM.user?.id ?? '',
              );
            }
            return taskVM;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Task Share',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: AppRoutes.login,
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}