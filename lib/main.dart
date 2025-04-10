import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/core/services/firebase_service.dart';
import 'package:to_do/core/utils/routes.dart';
import 'package:to_do/data/repositories/auth_repository.dart';
import 'package:to_do/data/repositories/task_repository.dart';
import 'package:to_do/presentation/view_models/auth_view_model.dart';
import 'package:to_do/presentation/view_models/task_view_model.dart';
import 'package:to_do/presentation/views/auth/app_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(create: (_) => AuthRepository()),
        ChangeNotifierProvider<AuthViewModel>(create: (context) => AuthViewModel(context.read<AuthRepository>())..initialize()),
        Provider<TaskRepository>(create: (_) => TaskRepository()),
        ChangeNotifierProxyProvider<AuthViewModel, TaskViewModel>(
          create:
              (context) => TaskViewModel(
                context.read<TaskRepository>(),
                context.read<AuthViewModel>().user?.id ?? '',
                context.read<AuthViewModel>().user?.email ?? '',
              ),
          update: (context, authVM, taskVM) {
            final newUserId = authVM.user?.id ?? '';
            final newUserEmail = authVM.user?.email ?? '';
            if (taskVM == null) {
              return TaskViewModel(context.read<TaskRepository>(), newUserId, newUserEmail);
            }

            if (taskVM.userId != newUserId) {
              taskVM.updateUserInfo(newUserId, newUserEmail);
              taskVM.loadTasks();
              taskVM.loadSharedTasks();
            }
            return taskVM;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Task Share',
        theme: ThemeData(primarySwatch: Colors.blue, visualDensity: VisualDensity.adaptivePlatformDensity),
        home: const AppEntry(),
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
