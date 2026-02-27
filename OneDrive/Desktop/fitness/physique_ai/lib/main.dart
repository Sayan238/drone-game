import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('user_profile');
  await Hive.openBox('progress_data');
  await Hive.openBox('habit_data');
  await Hive.openBox('app_settings');

  runApp(
    const ProviderScope(
      child: PhysiqueAIApp(),
    ),
  );
}
