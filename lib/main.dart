import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/features/initialization/logic/app_dependencies_factory.dart';
import 'package:notes/features/initialization/widget/scoped_app.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      _setupSystem();
      _setupBloc();

      final appDependenciesContainer = await AppDependenciesFactory().create();

      runApp(
        ScopedApp(
          appDependenciesContainer: appDependenciesContainer,
        ),
      );
    },
    (error, stackTrace) {
      print('$error$stackTrace');
    },
  );
}

void _setupSystem() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
  ));

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
}

void _setupBloc() {
  Bloc.transformer = bloc_concurrency.sequential();
}
