import 'import.dart';

final ThemeData appTheme = ThemeData(
  // fontFamily: 'Outfit',
  useMaterial3: true,
  primaryColor: const Color(0xFF022159),
  // Deep blue from your logo
  scaffoldBackgroundColor: Colors.white,
  // Clean background
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF022159), // Matches logo
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue, // Consistent with your primary color
  ).copyWith(
    primary: const Color(0xFF022159),
    secondary: const Color(0xFF053C73),
    // Accent color from your logo
    onPrimary: Colors.white,
    // Ensures good contrast on buttons
    background: Colors.white,
    // Clean app background
    surface: const Color(0xFFFFFFFF), // Light blue for card-like components
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Outfit',
      color: Color(0xFF022159),
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Outfit',
      color: Color(0xFF022159),
      fontSize: 18,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Outfit',
      color: Colors.black87,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Outfit',
      color: Colors.black54,
      fontSize: 14,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF053C73), // Accent color
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      textStyle: const TextStyle(
        fontFamily: 'Outfit',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.iconColor, width: 2),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.iconBg, width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    labelStyle: TextStyle(
      color: Color(0xFF022159),
      fontFamily: 'Outfit',
    ),
  ),
);
