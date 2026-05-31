import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/view/home.dart';
import 'package:movie_app/view/login.dart';


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
    
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.amber)),
          );
        }

        // 2. إذا وجدنا بيانات مستخدم، نفتح الصفحة الرئيسية
        if (snapshot.hasData) {
          return const HomePage();
        }

        // 3. إذا لم يجد مستخدم (null)، نفتح صفحة تسجيل الدخول
        return const LoginPage();
      },
    );
  }
}