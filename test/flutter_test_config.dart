import 'dart:async';

import 'package:google_fonts/google_fonts.dart';

/// Runs before every test file. Fonts must come from assets/google_fonts;
/// a missing weight fails loudly instead of trying the network.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  await testMain();
}
