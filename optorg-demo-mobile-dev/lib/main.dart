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
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: initializeProviders(), child: const OptorgApp()));
}

class OptorgApp extends StatelessWidget {
  const OptorgApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        useInheritedMediaQuery: true,

        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) => MaterialApp(
              title: appName,
              navigatorKey: AppNavigation.navigatorStateKey,
              theme: ThemeData(
                  primarySwatch: Colors.blue, brightness: Brightness.light),
              initialRoute: ROUTE_TO_SPLASHSCREEN,
              routes: {
                ROUTE_TO_SPLASHSCREEN: (context) => const SplashScreen(),
              },
              debugShowCheckedModeBanner: false,
              onGenerateRoute: onGenerateRoute,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('fr'),
                Locale('en'),
              ],
            ));
  }
}
