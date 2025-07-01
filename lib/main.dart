import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optorg_mobile/constants/routes.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/provider_initializer.dart';
import 'package:optorg_mobile/utils/app_navigation.dart';
import 'package:optorg_mobile/utils/routes_utils.dart';
import 'package:optorg_mobile/views/splashscreen/splash_screen.dart';
import 'package:optorg_mobile/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: initializeProviders(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      useInheritedMediaQuery: true,
      builder: (_, child) => MaterialApp(
        title: appName,
        navigatorKey: AppNavigation.navigatorStateKey,

        // Thème personnalisé combiné
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2563EB),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // Routes & navigation
        initialRoute: ROUTE_TO_SPLASHSCREEN,
        routes: {
          ROUTE_TO_SPLASHSCREEN: (context) => const SplashScreen(),
          // Si tu veux mettre la HomePage comme route fixe (optionnel)
          // '/home': (context) => const HomePage(),
        },
        onGenerateRoute: onGenerateRoute,

        debugShowCheckedModeBanner: false,

        // Localisations
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fr'),
          Locale('en'),
        ],

        // Si tu veux afficher la HomePage par défaut au lieu SplashScreen, tu peux remplacer initialRoute par :
        // home: const HomePage(),
      ),
    );
  }
}

