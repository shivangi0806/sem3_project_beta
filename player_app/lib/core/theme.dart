import 'package:flutter/material.dart';
import '';
const Color navyBlue = Color(0xFF0A1929); // Deep navy background

const Color navyBlueLight = Color(0xFF132F4C); // Card / surface color

const Color navyBlueMid = Color(0xFF1E3A5F); // Elevated surfaces

const Color accentBlue = Color(0xFF5090D3); // Primary accent

final darkNavyTheme = ThemeData(

 brightness: Brightness.dark,
 primaryColor: accentBlue,
 scaffoldBackgroundColor: navyBlue,
colorScheme: const ColorScheme.dark(
primary: accentBlue,
secondary: Color(0xFF66BB6A),
surface: navyBlueLight,

onPrimary: Colors.white,

onSecondary: Colors.white,
onSurface: Colors.white,
 ),
 appBarTheme: const AppBarTheme(
 backgroundColor: navyBlueLight,

 foregroundColor: Colors.white,

 elevation: 0,
 ),

 cardTheme: CardThemeData(

 color: navyBlueLight,

 elevation: 3,

 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),

 ),

 iconTheme: const IconThemeData(color: Colors.white70),

 textTheme: const TextTheme(

 bodyLarge: TextStyle(color: Colors.white),

 bodyMedium: TextStyle(color: Colors.white70),

 bodySmall: TextStyle(color: Colors.white54),

 titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), ),

); 