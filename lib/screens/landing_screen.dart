import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multivendor_vendor_app/firebase_service.dart';
import 'package:multivendor_vendor_app/model/vendor_model.dart';
import 'package:multivendor_vendor_app/screens/home_screen.dart';
import 'package:multivendor_vendor_app/screens/login_screen.dart';
import 'package:multivendor_vendor_app/screens/register_screen.dart';
import 'package:multivendor_vendor_app/screens/payment_issues.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServives _service = FirebaseServives();
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream: _service.vendor.doc(_service.user!.uid).snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.data!.exists) {
                return const RegisterationScreen();
              }
              VendorModel vendor = VendorModel.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>);

              if (vendor.approved == true && vendor.hasPaid == true) {
                return const HomeScreen();
              }
              if (vendor.approved == true && vendor.hasPaid == false) {
                return const HasNotPaid();
              }

              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                            imageUrl: vendor.shopImage!,
                            placeholder: (context, url) => Container(
                                  height: 80,
                                  width: 80,
                                  color: Colors.grey.shade300,
                                )),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      vendor.businessName!,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Text(
                      'Your Application has been to to Admin\ Admin will contact you soon',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut().then((value) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const LoginScreen(),
                              ),
                            );
                          });
                        },
                        child: const Text('Sign Out'))
                  ],
                ),
              );
            }));
  }
}
