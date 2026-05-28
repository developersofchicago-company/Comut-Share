import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'config/routes.dart';

class ComutShareApp extends StatelessWidget {
  const ComutShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ComutShare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
