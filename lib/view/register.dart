// lib/views/register_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:movie_app/services/auth_serv.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ستحتاج لهذا للـ signOut

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _authService = AuthService();
  bool _isLoading = false;

  // دالة التعامل مع التسجيل
  Future<void> _handleRegister() async {
    // 1. التحقق من صحة المدخلات
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;

    setState(() => _isLoading = true);
    
    final data = _formKey.currentState!.value;

    try {
      // 2. محاولة التسجيل عبر الخدمة
      String? result = await _authService.register(
        data['email'], 
        data['password'], 
        data['name'],
      );

      if (result == null) {
        // --- الجزء المهم لطلب الـ Login يدوياً ---
        await FirebaseAuth.instance.signOut(); 
        
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully! Please login.")),
        );

        // العودة لصفحة الـ Login (بافتراض أنها الصفحة السابقة أو معرفة في الـ Routes)
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // إظهار خطأ من فايربيز (مثل الإيميل مستخدم مسبقاً)
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An unexpected error occurred: $e")),
      );
    } finally {
      // التأكد من إغلاق الـ Loading مهما كانت النتيجة
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "Create Account", 
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                
                FormBuilderTextField(
                  name: 'name',
                  style: const TextStyle(color: Colors.white),
                  decoration: _buildDecoration("Full Name", Icons.person_outline),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 20),
                
                FormBuilderTextField(
                  name: 'email',
                  style: const TextStyle(color: Colors.white),
                  decoration: _buildDecoration("Email", Icons.email_outlined),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(), 
                    FormBuilderValidators.email(),
                  ]),
                ),
                const SizedBox(height: 20),
                
                FormBuilderTextField(
                  name: 'password',
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: _buildDecoration("Password", Icons.lock_outline),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(6, errorText: "Password must be at least 6 characters"),
                  ]),
                ),
                const SizedBox(height: 40),
                
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber, 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: _isLoading ? null : _handleRegister,
                    child: _isLoading 
                        ? const CircularProgressIndicator(color: Color(0xFF0D1B2A)) 
                        : const Text(
                            "REGISTER", 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label, 
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.amber),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15), 
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15), 
        borderSide: const BorderSide(color: Colors.amber),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15), 
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}