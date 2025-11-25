import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart'; // DÉSACTIVÉ - Utilisation de MySQL Backend
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'core/localization/app_translations.dart';
import 'core/routes/app_routes.dart';
// import 'core/services/notification_service.dart'; // DÉSACTIVÉ - Firebase
// import 'core/services/auth_service.dart'; // DÉSACTIVÉ - Firebase

import 'core/providers/auth_provider.dart' as CoreAuth;
import 'features/client/providers/appointment_provider.dart';
import 'features/client/providers/repair_provider.dart';
import 'features/technician/providers/technician_provider.dart';
import 'features/admin/providers/admin_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ❌ Firebase désactivé - Utilisation du backend Node.js/MySQL
  // Firebase nécessite des clés API valides que nous n'utilisons pas
  print('🚀 Démarrage de l\'application SAV avec backend MySQL');
  
  // Initialize Hive pour le stockage local
  await Hive.initFlutter();
  print('✅ Hive initialisé');
  
  runApp(const SAVApp());
}

class SAVApp extends StatelessWidget {
  const SAVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CoreAuth.AuthProvider()..init()),
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
