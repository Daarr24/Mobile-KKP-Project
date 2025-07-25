import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart'; // Added import for ApiService

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Image.asset(
                    'lib/assets/logo.png',
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                // Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(Icons.email_outlined),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (val) => _email = val,
                            validator: (val) => val == null || val.isEmpty
                                ? 'Email wajib diisi'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            obscureText: _obscure,
                            onChanged: (val) => _password = val,
                            validator: (val) => val == null || val.isEmpty
                                ? 'Password wajib diisi'
                                : null,
                          ),
                          const SizedBox(height: 24),
                          if (authProvider.isLoading)
                            const CircularProgressIndicator(),
                          if (authProvider.error != null) ...[
                            Text(
                              authProvider.error!,
                              style: const TextStyle(color: Color(0xFFDC2626)),
                            ),
                            const SizedBox(height: 10),
                          ],
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDC2626),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: authProvider.isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        final success = await authProvider
                                            .login(_email, _password);
                                        if (success && mounted) {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            '/dashboard',
                                          );
                                        }
                                      }
                                    },
                              child: const Text('Login'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF457B9D),
                                side: const BorderSide(
                                  color: Color(0xFF457B9D),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: () async {
                                // Dialog input register
                                final result = await showDialog<Map<String, String>>(
                                  context: context,
                                  builder: (context) {
                                    String name = '';
                                    String email = '';
                                    String password = '';
                                    String? emailError;
                                    String? passwordError;
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Register User Baru',
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                decoration:
                                                    const InputDecoration(
                                                      labelText: 'Nama',
                                                    ),
                                                onChanged: (val) => name = val,
                                              ),
                                              TextField(
                                                decoration: InputDecoration(
                                                  labelText: 'Email',
                                                  errorText: emailError,
                                                ),
                                                onChanged: (val) {
                                                  email = val;
                                                  setState(
                                                    () => emailError = null,
                                                  );
                                                },
                                              ),
                                              TextField(
                                                decoration: InputDecoration(
                                                  labelText: 'Password',
                                                  errorText: passwordError,
                                                ),
                                                obscureText: true,
                                                onChanged: (val) {
                                                  password = val;
                                                  setState(
                                                    () => passwordError = null,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Batal'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                final emailRegex = RegExp(
                                                  r'^.+@.+\\..+ 0$',
                                                );
                                                bool valid = true;
                                                if (!emailRegex.hasMatch(
                                                  email,
                                                )) {
                                                  setState(
                                                    () => emailError =
                                                        'Format email tidak valid',
                                                  );
                                                  valid = false;
                                                }
                                                if (password.length < 8) {
                                                  setState(
                                                    () => passwordError =
                                                        'Password minimal 8 karakter',
                                                  );
                                                  valid = false;
                                                }
                                                if (name.isEmpty ||
                                                    email.isEmpty ||
                                                    password.isEmpty) {
                                                  valid = false;
                                                }
                                                if (valid) {
                                                  Navigator.pop(context, {
                                                    'name': name,
                                                    'email': email,
                                                    'password': password,
                                                  });
                                                }
                                              },
                                              child: const Text('Register'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                                if (result != null) {
                                  final reg = await ApiService().registerUser(
                                    name: result['name']!,
                                    email: result['email']!,
                                    password: result['password']!,
                                  );
                                  if (!mounted) return;
                                  if (reg['statusCode'] == 201) {
                                    setState(() {
                                      _email = result['email']!;
                                    });
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        reg['statusCode'] == 201
                                            ? 'Registrasi berhasil! Silakan login.'
                                            : 'Registrasi gagal: ${reg['body']}',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Register User Baru'),
                            ),
                          ),
                        ],
                      ),
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
}
