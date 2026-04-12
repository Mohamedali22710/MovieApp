import 'package:flutter/material.dart';
import 'package:movie_app/provider/auth.dart';
import 'package:movie_app/provider/movie.dart';
import 'package:movie_app/view/home.dart';
import 'package:movie_app/view/login.dart';
import 'package:movie_app/view/splash.dart';
import 'package:provider/provider.dart';

import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // تحميل المفضلات فور إنشاء البروفايدر
        ChangeNotifierProvider(create: (_) => MovieProvider()..loadFavorites()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Explorer',
      theme: ThemeData(
        brightness: Brightness.dark, 
        primaryColor: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF0D1B2A), 
      ),
      

      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), 
        Locale('ar'), 
      ],

      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        
      },
    );
  }
}