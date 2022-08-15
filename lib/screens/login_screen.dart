import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:multivendor_vendor_app/screens/landing_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return SignInScreen(
              headerBuilder: (context, constraints, _) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: Center(
                        child: Text(
                          'Mobile Marche',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      )),
                );
              },
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    action == AuthAction.signIn
                        ? 'Welcome to Mobile Marche ! Please sign in to continue.'
                        : 'Welcome to Mobile Marche ! Please create an account to continue',
                  ),
                );
              },
              footerBuilder: (context, _) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'By signing in, you agree to our terms and conditions.',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                );
              },
              providerConfigs: const [
                EmailProviderConfiguration(),
                GoogleProviderConfiguration(
                    clientId: '1:742424249689:android:62880baee347a287d1f848')
              ]);
        }

        // Render your application if authenticated
        return const LandingScreen();
      },
    );
  }
}
