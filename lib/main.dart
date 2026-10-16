import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/bindings/app_binding.dart';
import 'app/constants/app_strings.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'data/services/notification_service.dart';
import 'firebase_options.dart';
import 'shared/widgets/curved_header.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _setUpFonts();
  SystemChrome.setSystemUIOverlayStyle(CurvedHeader.overlayStyle);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register app-wide services, then set up timezones and notifications
  // before the first screen so a reminder that launched the app is known.
  AppBinding().dependencies();
  await Get.find<NotificationService>().init();

  runApp(const TodoApp());
}

/// Fonts are bundled in assets/google_fonts, so never download them, and
/// show their SIL Open Font License on the licenses page.
void _setUpFonts() {
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    for (final font in ['Inter', 'PlusJakartaSans']) {
      final license = await rootBundle.loadString(
        'assets/google_fonts/$font-OFL.txt',
      );
      yield LicenseEntryWithLineBreaks([font], license);
    }
  });
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    );
  }
}
