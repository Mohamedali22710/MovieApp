// // lib/views/login_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:movie_app/provider/auth.dart';
// import 'package:provider/provider.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   bool _isPasswordVisible = false;

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthProvider>(context);

//     return Scaffold(
//       backgroundColor: const Color(0xFF0D1B2A), // Deep Blue Background
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: FormBuilder(
//             key: auth.formKey,
//             child: Column(
//               children: [
//                 const Icon(Icons.movie_filter, size: 80, color: Colors.amber),
//                 const SizedBox(height: 20),
//                 const Text("Welcome Back",
//                     style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 40),

//                 // حقل اليوزر نيم
//                 FormBuilderTextField(
//                   name: 'username',
//                   style: const TextStyle(color: Colors.white),
//                   decoration: _buildInputDecoration("Username", Icons.person_outline),
//                   validator: FormBuilderValidators.required(errorText: "Please enter your username"),
//                 ),
//                 const SizedBox(height: 20),

                
//                 FormBuilderTextField(
//                   name: 'password',
//                   obscureText: !_isPasswordVisible,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: _buildInputDecoration("Password", Icons.lock_outline).copyWith(
//                     suffixIcon: IconButton(
//                       icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//                           color: Colors.amber),
//                       onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
//                     ),
//                   ),
//                   validator: FormBuilderValidators.required(errorText: "Please enter your password"),
//                 ),
//                 const SizedBox(height: 40),

              
//                 SizedBox(
//                   width: double.infinity,
//                   height: 55,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.amber,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                     ),
//                     onPressed: auth.isLoading
//                         ? null
//                         : () async {
                   
//                             bool success = await auth.login();

                         
//                             if (!context.mounted) return;

                           
//                             if (success) {
//                               Navigator.pushReplacementNamed(context, '/home');
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text("Invalid Credentials! Check username or password"),
//                                   backgroundColor: Colors.red,
//                                   behavior: SnackBarBehavior.floating,
//                                 ),
//                               );
//                             } 
//                           },
//                     child: auth.isLoading
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(color: Color(0xFF0D1B2A), strokeWidth: 2))
//                         : const Text("LOGIN",
//                             style: TextStyle(
//                                 color: Color(0xFF0D1B2A), fontWeight: FontWeight.bold, fontSize: 18)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   InputDecoration _buildInputDecoration(String label, IconData icon) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(color: Colors.white70),
//       prefixIcon: Icon(icon, color: Colors.amber),
//       enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white24)),
//       focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.amber)),
//       filled: true,
//       fillColor: Colors.white.withOpacity(0.05),
//     );
//   }
// }

// lib/views/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:movie_app/services/auth_serv.dart';
import 'package:movie_app/view/register.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _authService = AuthService();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.amber),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white24)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.amber)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.movie_filter, size: 80, color: Colors.amber),
                const SizedBox(height: 20),
                const Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                
                // حقل الإيميل (يفضل استخدام الإيميل بدلاً من اليوزر نيم للـ Auth)
                FormBuilderTextField(
                  name: 'email',
                  style: const TextStyle(color: Colors.white),
                  decoration: _buildInputDecoration("Email", Icons.email_outlined),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
                const SizedBox(height: 20),

                FormBuilderTextField(
                  name: 'password',
                  obscureText: !_isPasswordVisible,
                  style: const TextStyle(color: Colors.white),
                  decoration: _buildInputDecoration("Password", Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.amber),
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ),
                  validator: FormBuilderValidators.required(),
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
                    onPressed: _isLoading ? null : () async {
                      if (_formKey.currentState!.saveAndValidate()) {
                        setState(() => _isLoading = true);
                        final data = _formKey.currentState!.value;
                        bool success = await _authService.login(data['email'], data['password']);
                        setState(() => _isLoading = false);

                        if (success) {
                          Navigator.pushReplacementNamed(context, '/home');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Failed!")));
                        }
                      }
                    },
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Color(0xFF0D1B2A)) 
                      : const Text("LOGIN", style: TextStyle(color: Color(0xFF0D1B2A), fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
                  child: const Text("Don't have an account? Register Now", style: TextStyle(color: Colors.amber)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}