import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod import

// Your screens
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
import 'providers/connectivity_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(
    const ProviderScope( // Wrap the app with ProviderScope for Riverpod
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ConsumerWidget(
        builder: (context, ref, _) {
          final isDark = ref.watch(themeProvider);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Eclipse',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.amber,
                brightness: isDark ? Brightness.dark : Brightness.light,
              ),
              textTheme: GoogleFonts.playfairDisplayTextTheme(),
              useMaterial3: true,
            ),
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
