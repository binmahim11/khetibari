import 'package:flutter/material.dart';
import 'package:khetibari/screens/auth_service.dart';
import 'package:khetibari/screens/firestore_service.dart';
import 'package:khetibari/screens/homepage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final email = TextEditingController();
  final pass = TextEditingController();
  final auth = AuthService();
  final db = FirestoreService();
  bool loading = false;

  Future<void> signup() async {
    if (email.text.trim().isEmpty || pass.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    if (pass.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    setState(() => loading = true);
    try {
      final user = await auth.signup(email.text.trim(), pass.text.trim());
      if (user != null) {
        await db.saveUserProfile(user.uid, {
          'email': email.text.trim(),
          'createdAt': DateTime.now(),
        });
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: pass,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : signup,
              child: Text(loading ? '...' : 'Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}


