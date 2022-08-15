import 'package:cloud_firestore/cloud_firestore.dart';

class VendorModel {
  VendorModel(
      {this.state,
      this.approved,
      this.businessName,
      this.businessType,
      this.city,
      this.contactNumber,
      this.country,
      this.email,
      this.logo,
      this.shopImage,
      this.time,
      this.uid,
      this.hasPaid});

  VendorModel.fromJson(Map<String, Object?> json)
      : this(
          state: json['state'] as String,
          approved: json['approved'] as bool,
          businessName: json['businessName'] as String,
          city: json['city'] as String,
          businessType: json['businessType'] as String,
          contactNumber: json['contactNumber'] as String,
          country: json['country'] as String,
          email: json['email'] as String,
          logo: json['logo'] as String,
          shopImage: json['shopImage'] as String,
          time: json['time'] as Timestamp,
          uid: json['uid'] as String,
          hasPaid: json['hasPaid'] as bool,
        );

  final String? state;
  final bool? approved;
  final String? businessName;
  final String? businessType;
  final String? city;
  final String? contactNumber;
  final String? country;
  final String? email;
  final String? logo;
  final String? shopImage;
  final Timestamp? time;
  final String? uid;
  final bool? hasPaid;

  Map<String, Object?> toJson() {
    return {
      'shopImage': shopImage,
      'logo': logo,
      'businessName': businessName,
      'contactNumber': contactNumber,
      'email': email,
      'businessType': businessType,
      'country': country,
      'hasPaid': hasPaid,
      'state': state,
      'city': city,
      'approved': false,
      'uid': uid,
      'time': DateTime.now()
    };
  }
}
