import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> initHive() async { // init hive untuk mobile
  // sediakan jalur penyimpanan
  final appDocumentDirectory = await getApplicationDocumentsDirectory();

  // inisialisai hive
  Hive.init(appDocumentDirectory.path);
}
