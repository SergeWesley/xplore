import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'app.dart';
import 'features/apod/domain/entities/apod_entity.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([ApodEntitySchema], directory: dir.path);

  await initDependencies(isar);

  runApp(const MyApp());
}
