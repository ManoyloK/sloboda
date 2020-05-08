import 'dart:io';

import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride, kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:sloboda/doc_generator/doc_generator_app.dart';

void _setTargetPlatformForDesktop() {
  // No need to handle macOS, as it has now been added to TargetPlatform.
  if (Platform.isLinux || Platform.isWindows) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() async {
  if (!kIsWeb) {
    _setTargetPlatformForDesktop();
  }
  runApp(
    DocGeneratorApp(),
  );
}
