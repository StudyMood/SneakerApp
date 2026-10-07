// ============================================================================
// [START] FILE: main.dart
// ============================================================================
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'constants/theme.dart';
import 'providers/cart_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/order_provider.dart';
import 'providers/sneaker_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/wishlist_provider.dart';
import 'services/firebase_service.dart';
import 'services/notification_service.dart';
import 'screens/splash_screen.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await FirebaseService.instance.initialize();
  runApp(const SneakrApp());
}

class SneakrApp extends StatelessWidget {
  const SneakrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => SneakerProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'SNEAKER',
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: NotificationService.messengerKey,
            navigatorKey: NotificationService.navigatorKey,
            scrollBehavior: AppScrollBehavior(),
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
// ============================================================================
// [END] FILE: main.dart
// ============================================================================
