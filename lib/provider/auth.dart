// lib/providers/auth_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:movie_app/model/user_model.dart';
import 'package:movie_app/services/auth_serv.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthProvider with ChangeNotifier {
  final formKey = GlobalKey<FormBuilderState>();
  final AuthService _authService = AuthService(); // بينادي السيرفيس مباشرة

  UserModel? user;
  bool isLoading = false;

  Future<bool> login() async {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      isLoading = true;
      notifyListeners();

      final formData = formKey.currentState!.value;
      
      try {
      
        user = await _authService.login(formData['username'], formData['password']);
        
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("userData", jsonEncode(user!.toJson())); 

        isLoading = false;
        notifyListeners();
        return true;
      } catch (e) {
        debugPrint("Login Error: $e");
      }
      
      isLoading = false;
      notifyListeners();
      return false;
    }
    return false;
  }


  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return;
    
    final extractedData = jsonDecode(prefs.getString('userData')!) as Map<String, dynamic>;
    user = UserModel.fromJson(extractedData);
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("userData");
    user = null;
    notifyListeners();
  }
}