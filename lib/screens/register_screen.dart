import 'dart:io';

import 'package:csc_picker/csc_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multivendor_vendor_app/firebase_service.dart';
import 'package:multivendor_vendor_app/screens/landing_screen.dart';

class RegisterationScreen extends StatefulWidget {
  const RegisterationScreen({Key? key}) : super(key: key);

  @override
  State<RegisterationScreen> createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  final FirebaseServives _servives = FirebaseServives();
  final _formKey = GlobalKey<FormState>();
  final _businessName = TextEditingController();
  final _contactNumber = TextEditingController();
  final _email = TextEditingController();

  String? busiName;
  String? _sellerType;
  XFile? _shopImage;
  XFile? logoImage;
  String? countryValue;
  String? stateValue;
  String? cityValue;
  String? _shopImageUrl;
  String? _logoUrl;
  //String address = "";
  final ImagePicker _picker = ImagePicker();
  Widget _formField(
      {TextEditingController? controller,
      String? label,
      TextInputType? type,
      String? Function(String?)? validator}) {
    return TextFormField(
      keyboardType: type,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: validator,
      onChanged: (value) {
        if (controller == _businessName) {
          setState(() {
            busiName = value;
          });
        }
      },
    );
  }

  Future<XFile?> _pickImages() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    return image;
  }

  _scaffold(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: message,
        action: SnackBarAction(
          label: 'ok',
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
          },
        ),
      ),
    );
  }

  saveToDB() {
    if (_shopImage == null) {
      _scaffold(const Text('Shop Image isn\'nt Uploaded'));
      return;
    }
    if (logoImage == null) {
      _scaffold(const Text('Shop Logo Image isn\'nt Uploaded'));
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (countryValue == null || stateValue == null || cityValue == null) {
        _scaffold(const Text('Select Address field completely'));
        return;
      }
      EasyLoading.show(status: 'Please wait...');
      _servives
          .uploadImage(
              _shopImage, 'vendor/${_servives.user!.uid}/shopImage.jpg')
          .then((url) {
        if (url != null) {
          setState(() {
            _shopImageUrl = url;
          });
        }
      }).then((value) {
        _servives
            .uploadImage(
                logoImage, 'vendor/${_servives.user!.uid}/shopLogo.jpg')
            .then((url) {
          if (url != null) {
            setState(() {
              _logoUrl = url;
            });
          }
        }).then((value) {
          _servives.addVendor(data: {
            'shopImage': _shopImageUrl,
            'logo': _logoUrl,
            'businessName': _businessName.text,
            'contactNumber': _contactNumber.text,
            'email': _email.text,
            'businessType': _sellerType,
            'country': countryValue,
            'state': stateValue,
            'city': cityValue,
            'approved': false,
            'uid': _servives.user!.uid,
            'time': DateTime.now()
          }).then((value) {
            EasyLoading.dismiss();
            return Navigator.of(context)
                .pushReplacement(MaterialPageRoute<void>(
              builder: (BuildContext context) => const LandingScreen(),
            ));
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: Stack(
                  children: [
                    _shopImage == null
                        ? Container(
                            height: 250,
                            color: Colors.blue,
                            child: TextButton(
                              onPressed: () {
                                _pickImages().then((value) {
                                  setState(() {
                                    _shopImage = value;
                                  });
                                });
                              },
                              child: const Center(
                                  child: Text(
                                'Tap to Add Shop Image',
                                style: TextStyle(color: Colors.grey),
                              )),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              _pickImages().then((value) {
                                setState(() {
                                  _shopImage = value;
                                });
                              });
                            },
                            child: Container(
                              height: 250,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  image: DecorationImage(
                                      opacity: 100,
                                      image: FileImage(File(_shopImage!.path)),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                    SizedBox(
                        height: 80,
                        child: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          actions: [
                            IconButton(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                },
                                icon: const Icon(Icons.exit_to_app))
                          ],
                        )),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  _pickImages().then((value) {
                                    setState(() {
                                      logoImage = value;
                                    });
                                  });
                                },
                                child: Card(
                                  child: logoImage == null
                                      ? const SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: Center(child: Text('+')),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: FileImage(
                                                        File(logoImage!.path)),
                                                    fit: BoxFit.cover)),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                              child: Text(
                                busiName == null ? '' : busiName!,
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Column(
                  children: [
                    _formField(
                        controller: _businessName,
                        label: 'Business Name',
                        type: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Business Name';
                          }
                        }),
                    _formField(
                        controller: _contactNumber,
                        label: 'Contact Number',
                        type: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Contact Number';
                          }
                        }),
                    _formField(
                        controller: _email,
                        label: 'Email',
                        type: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Email Address';
                          }
                          bool _isValid = (EmailValidator.validate(value));
                          if (_isValid == false) {
                            return 'Invalid Email, Please enter a valid email';
                          }
                        }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Business Type'),
                        const SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: DropdownButtonFormField(
                            value: _sellerType,
                            hint: const Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Text(' Select Business Type'),
                            ),
                            items: <String>[
                              'Retailer',
                              'WholeSaler',
                              'Distributor'
                            ].map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _sellerType = value as String?;
                              });
                            },
                            validator: (String? value) {
                              if (value == null) {
                                return 'Please Select a type';
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CSCPicker(
                        ///Enable disable state dropdown [OPTIONAL PARAMETER]
                        showStates: true,

                        /// Enable disable city drop down [OPTIONAL PARAMETER]
                        showCities: true,

                        ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                        flagState: CountryFlag.ENABLE,

                        ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                        dropdownDecoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1)),

                        ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                        disabledDropdownDecoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: Colors.grey.shade300,
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1)),

                        ///placeholders for dropdown search field
                        countrySearchPlaceholder: "Country",
                        stateSearchPlaceholder: "State",
                        citySearchPlaceholder: "City",

                        ///labels for dropdown
                        countryDropdownLabel: "Country",
                        stateDropdownLabel: "State",
                        cityDropdownLabel: "City",

                        ///Default Country
                        // defaultCountry: DefaultCountry.Mali,

                        ///Disable country dropdown (Note: use it with default country)
                        //disableCountry: true,

                        ///selected item style [OPTIONAL PARAMETER]
                        selectedItemStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),

                        ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                        dropdownHeadingStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),

                        ///DropdownDialog Item style [OPTIONAL PARAMETER]
                        dropdownItemStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),

                        ///Dialog box radius [OPTIONAL PARAMETER]
                        dropdownDialogRadius: 10.0,

                        ///Search bar radius [OPTIONAL PARAMETER]
                        searchBarRadius: 10.0,

                        ///triggers once country selected in dropdown
                        onCountryChanged: (value) {
                          setState(() {
                            ///store value in country variable
                            countryValue = value;
                          });
                        },

                        ///triggers once state selected in dropdown
                        onStateChanged: (value) {
                          setState(() {
                            ///store value in state variable
                            stateValue = value;
                          });
                        },

                        ///triggers once city selected in dropdown
                        onCityChanged: (value) {
                          setState(() {
                            ///store value in city variable
                            cityValue = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        persistentFooterButtons: [
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: saveToDB, child: const Text('Register')),
              )),
            ],
          )
        ],
      ),
    );
  }
}
