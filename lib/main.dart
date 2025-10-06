import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';



//  screens
import 'package:eclipse/screens/auth/login_screen.dart';
import 'package:eclipse/screens/auth/register_screen.dart';
import 'package:eclipse/screens/cart_screen.dart';
import 'package:eclipse/screens/home_screen.dart';
import 'package:eclipse/screens/payment_screen.dart';
import 'package:eclipse/screens/product_detail_screen.dart';
import 'package:eclipse/screens/product_page_screen.dart';
import 'package:eclipse/screens/profile_screen.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/products_provider.dart';
import 'providers/cart_provider.dart';
import 'package:eclipse/services/connectivity_service.dart';
import 'providers/theme_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  await dotenv.load(fileName: ".env");
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ref, _) {
          final isDark = ref.watch(themeProvider);

          // Initialize connectivity service
          ref.read(connectivityServiceProvider);

          // Watch connectivity status
          final isOnline = ref.watch(isOnlineProvider);

          return  MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Eclipse',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

            // Add offline banner
            builder: (context, child) {
              return Stack(
                children: [
                  child ?? const SizedBox.shrink(),

                  // Offline Banner
                  if (!isOnline)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Material(
                        color: Colors.red,
                        elevation: 4,
                        child: SafeArea(
                          bottom: false,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.wifi_off,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'No Internet Connection',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },

            initialRoute: '/login',
            routes: {
              '/login': (_) => const LoginScreen(),
              '/register': (_) => const RegisterScreen(),
              '/home': (_) => const HomeScreen(),
              '/products': (_) => const ProductPageScreen(),
              '/product-detail': (_) => const ProductDetailScreen(),
              '/cart': (_) => const CartScreen(),
              '/payment': (_) => const PaymentScreen(),
              '/profile': (_) => ProfileScreen(
                isDarkMode: isDark,
                onToggleTheme: () => ref.read(themeProvider.notifier).toggle(),
              ),
            },
          );
        }
    );
  }
}

// Theme Provider using Riverpod
final themeProvider = StateNotifierProvider<ThemeController, bool>((ref) {
  return ThemeController()..load();
});

class ThemeController extends StateNotifier<bool> {
  ThemeController() : super(false);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('dark') ?? false;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark', state);
  }
}


final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.black,
    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      secondary: Color(0xFFD4AF37),
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    textTheme: GoogleFonts.ralewayTextTheme(
      ThemeData.light().textTheme,
    ),
  );

  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: Color(0xFFD4AF37),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1E1E1E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: GoogleFonts.ralewayTextTheme(
      ThemeData.dark().textTheme,
    ),
  );


class AuthWrapper extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const AuthWrapper({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return const LoginScreen(); // You could pass isDarkMode/onToggleTheme here too if needed.
  }
}

