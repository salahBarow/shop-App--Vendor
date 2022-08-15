import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class FirebaseServives {
  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference vendor = FirebaseFirestore.instance.collection('vendor');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  CollectionReference mainCategories =
      FirebaseFirestore.instance.collection('maiCategories');
  CollectionReference subCategories =
      FirebaseFirestore.instance.collection('subCategories');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> uploadImage(XFile? file, String? reference) async {
    File _file = File(file!.path);
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(reference);

    await ref.putFile(_file);
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> addVendor({Map<String, dynamic>? data}) {
    return vendor
        .doc(user!.uid)
        .set(data)
        .then((value) => debugPrint("User Added"))
        .catchError((error) => debugPrint("Failed to add user: $error"));
  }

  formatedDate(date) {
    var outputFormat = DateFormat('dd / mm / yyyy hh:mm aa');
    var outPutDate = outputFormat.format(date);
    return outPutDate;
  }

  Widget formField(
      {String? label,
      TextInputType? type,
      void Function(String)? onChanged,
      int? minLine,
      int? maxLine}) {
    return TextFormField(
      keyboardType: type,
      decoration: InputDecoration(
        label: Text(label!),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return label;
        }
      },
      onChanged: onChanged,
      minLines: minLine,
      maxLines: maxLine,
    );
  }
}
