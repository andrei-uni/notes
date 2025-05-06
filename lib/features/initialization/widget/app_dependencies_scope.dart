import 'package:flutter/material.dart';
import 'package:notes/features/initialization/models/app_dependencies_container.dart';

class AppDependenciesScope extends InheritedWidget {
  const AppDependenciesScope({
    required this.appDependenciesContainer,
    required super.child,
    super.key,
  });

  final AppDependenciesContainer appDependenciesContainer;

  static AppDependenciesContainer of(BuildContext context) {
    final widget = context.getInheritedWidgetOfExactType<AppDependenciesScope>();
    assert(widget != null, 'No $AppDependenciesScope found in context');
    return widget!.appDependenciesContainer;
  }

  @override
  bool updateShouldNotify(AppDependenciesScope oldWidget) => false;
}
