import 'package:flutter/material.dart';
import 'package:notes/features/initialization/models/app_dependencies_container.dart';
import 'package:notes/features/initialization/widget/app_dependencies_scope.dart';
import 'package:notes/features/initialization/widget/main_app.dart';

class ScopedApp extends StatelessWidget {
  const ScopedApp({
    required this.appDependenciesContainer,
    super.key,
  });

  final AppDependenciesContainer appDependenciesContainer;

  @override
  Widget build(BuildContext context) {
    return AppDependenciesScope(
      appDependenciesContainer: appDependenciesContainer,
      child: const MainApp(),
    );
  }
}
