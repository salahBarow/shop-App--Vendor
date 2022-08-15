import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:multivendor_vendor_app/screens/add_product_screen.dart';
import 'package:multivendor_vendor_app/screens/home_screen.dart';
import 'package:multivendor_vendor_app/screens/login_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multivendor_vendor_app/screens/product_screen.dart';
import 'package:provider/provider.dart';

import 'provider/product_provider.dart';
import 'provider/vendor_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(MultiProvider(
    providers: [
      Provider<VendorProvider>(create: (_) => VendorProvider()),
      Provider<ProductProvider>(create: (_) => ProductProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
        ProductScreen.id: (context) => const ProductScreen(),
        AddProductScreen.id: (context) => const AddProductScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const LoginScreen(),
          ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
        'Vendor App',
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
      )),
    );
  }
}
