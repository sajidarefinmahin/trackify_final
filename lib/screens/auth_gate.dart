import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  final Widget? home;

  const AuthGate({
    super.key,
    this.home,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          final user = snapshot.data;
          final providedHome = home;
          if (providedHome != null && providedHome is! AppStart) {
            return providedHome;
          }
          return AppStart(
            key: ValueKey(user?.uid ?? 'authenticated_user'),
            userId: user?.uid,
          );
        }

        return LoginScreen(
          onLoginSuccess: () {},
        );
      },
    );
  }
}
