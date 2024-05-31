import 'package:flutter/foundation.dart' show kIsWeb;

export 'app_initializer_mobile.dart' if (dart.library.html) 'app_initializer_web.dart';