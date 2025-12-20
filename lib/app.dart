import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/apod/presentation/cubit/apod_cubit.dart';
import 'features/apod/presentation/pages/apod_page.dart';
import 'injection_container.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XPlore',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => getIt<ApodCubit>(),
        child: const ApodPage(),
      ),
    );
  }
}
