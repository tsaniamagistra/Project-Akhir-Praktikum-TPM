import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHive() async { // init hive untuk web
  await Hive.initFlutter();
}
