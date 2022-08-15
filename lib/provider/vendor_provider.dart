import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multivendor_vendor_app/firebase_service.dart';

class VendorProvider with ChangeNotifier {
  final FirebaseServives _servives = FirebaseServives();
  DocumentSnapshot? doc;

  getVendorData() {
    _servives.vendor.doc(_servives.user!.uid).get().then((document) {
      doc = document;
      notifyListeners();
    });
  }
}
