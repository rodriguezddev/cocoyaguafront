import 'package:flutter/material.dart';
import 'package:cocoyagua/ui/theme/app_theme.dart';
import 'package:cocoyagua/ui/views/login/login_view.dart';
import 'package:cocoyagua/ui/views/dashboard/dashboard_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  void handleLogin() {
    setState(() => isLoggedIn = true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cocoyagua',
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      home:
          isLoggedIn ? const DashboardView() : LoginView(onLogin: handleLogin),
    );
  }
}
