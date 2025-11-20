import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'core/localization/app_translations.dart';
import 'core/routes/app_routes.dart';
import 'core/services/notification_service.dart';
import 'core/services/auth_service.dart';

import 'features/auth/providers/auth_provider.dart';
import 'features/client/providers/appointment_provider.dart';
import 'features/client/providers/repair_provider.dart';
import 'features/technician/providers/technician_provider.dart';
import 'features/admin/providers/admin_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (only if options are configured)
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "YOUR_API_KEY",
        authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
        projectId: "YOUR_PROJECT_ID",
        storageBucket: "YOUR_PROJECT_ID.appspot.com",
        messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
        appId: "YOUR_APP_ID",
      ),
    );
  } catch (e) {
    print('Firebase initialization skipped: $e');
  }
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize Services (skip if Firebase failed)
  try {
    await NotificationService.initialize();
    await AuthService.initialize();
  } catch (e) {
    print('Services initialization skipped: $e');
  }
  
  runApp(const SAVApp());
}

class SAVApp extends StatelessWidget {
  const SAVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => RepairProvider()),
        ChangeNotifierProvider(create: (_) => TechnicianProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: GetMaterialApp(
        title: 'SAV App',
        debugShowCheckedModeBanner: false,
        
        // Theme
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        
        // Localization
        translations: AppTranslations(),
        locale: const Locale('fr', 'FR'),
        fallbackLocale: const Locale('fr', 'FR'),
        supportedLocales: const [
          Locale('fr', 'FR'),
          Locale('en', 'US'),
          Locale('ar', 'SA'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        
        // Routes
        initialRoute: AppRoutes.splash,
        getPages: AppRoutes.routes,
      ),
    );
  }
}
