import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multivendor_vendor_app/firebase_service.dart';
import 'package:multivendor_vendor_app/provider/product_provider.dart';
import 'package:provider/provider.dart';

class GeneralTab extends StatefulWidget {
  const GeneralTab({Key? key}) : super(key: key);

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseServives _servives = FirebaseServives();
  final List<String> _categories = [];
  String? _selectedCategory;
  String? _soldAs;
  bool _discount = false;
  String? whole = 'WholeSale';
  String? retail = 'Retail';

  Widget _categoryDropDown(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      hint: const Text('Sellect Category'),
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCategory = newValue!;
          provider.getFormData(category: newValue);
        });
      },
      items: _categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        return 'Select Category';
      },
    );
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  // getting categories from firebase
  getCategories() {
    _servives.categories.get().then((value) {
      for (var element in value.docs) {
        setState(() {
          _categories.add(element['catName']);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              _servives.formField(
                label: 'Product Name',
                type: TextInputType.text,
                onChanged: (value) {
                  provider.getFormData(productName: value);
                },
              ),
              _categoryDropDown(provider),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 8),
                    child: Text(
                      provider.productInfo!['mainCategory'] ??
                          'Sellect Main Category',
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade800),
                    ),
                  ),
                  if (_selectedCategory != null)
                    InkWell(
                        onTap: () {
                          showGeneralDialog(
                              barrierLabel: 'Close',
                              barrierDismissible: true,
                              context: context,
                              pageBuilder: (BuildContext context, _, __) {
                                return MainCategoryList(
                                  sellectedCat: _selectedCategory,
                                  provider: provider,
                                );
                              }).whenComplete(() {
                            setState(() {});
                          });
                        },
                        child: const Icon(Icons.arrow_drop_down))
                ],
              ),
              const Divider(
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 8),
                    child: Text(
                      provider.productInfo!['subCategory'] ??
                          'Sellect Sub Category',
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade800),
                    ),
                  ),
                  if (provider.productInfo!['mainCategory'] != null)
                    InkWell(
                        onTap: () {
                          showGeneralDialog(
                              barrierLabel: 'Close',
                              barrierDismissible: true,
                              context: context,
                              pageBuilder: (BuildContext context, _, __) {
                                return SubCategoryList(
                                  sellectedMainCat:
                                      provider.productInfo!['mainCategory'],
                                  provider: provider,
                                );
                              }).whenComplete(() {
                            setState(() {});
                          });
                        },
                        child: const Icon(Icons.arrow_drop_down))
                ],
              ),
              const Divider(
                color: Colors.black,
              ),
              DropdownButtonFormField(
                value: _soldAs,
                hint: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Text(' Selling in'),
                ),
                items: <String?>[
                  retail,
                  whole,
                ].map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value!));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _soldAs = value as String?;
                  });
                },
                validator: (String? value) {
                  if (value == null) {
                    return 'Please Select a type';
                  }
                },
              ),
              if (_soldAs == whole)
                _servives.formField(
                  label: 'Minimum Sold',
                  type: TextInputType.number,
                  onChanged: (value) {
                    provider.getFormData(minSold: int.parse(value));
                  },
                ),
              _servives.formField(
                label: 'Price',
                type: TextInputType.number,
                onChanged: (value) {
                  provider.getFormData(price: int.parse(value));
                },
              ),
              _servives.formField(
                label: 'Discount Price',
                type: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    provider.getFormData(salePrice: int.parse(value));
                    _discount = true;
                  });
                },
              ),
              if (_discount)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      child: const Center(
                        child: Text(
                          'Schedule',
                        ),
                      ),
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(5000))
                            .then((value) {
                          setState(() {
                            provider.getFormData(schedule: value);
                          });
                        });
                      },
                    ),
                    if (provider.productInfo!['schedule'] != null)
                      Text(_servives
                          .formatedDate(provider.productInfo!['schedule']))
                  ],
                )
            ],
          ),
        );
      },
    );
  }
}

class MainCategoryList extends StatelessWidget {
  final String? sellectedCat;
  final ProductProvider? provider;
  const MainCategoryList({Key? key, this.sellectedCat, this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServives _service = FirebaseServives();
    return Dialog(
      child: FutureBuilder<QuerySnapshot>(
        future: _service.mainCategories
            .where('category', isEqualTo: sellectedCat)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.size == 0) {
            return const Center(
              child: Text('This Category does not any main categories yet'),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () {
                      provider!.getFormData(
                          mainCategory: snapshot.data!.docs[index]
                              ['mainCategory']);
                      Navigator.pop(context);
                    },
                    title: Text(
                      snapshot.data!.docs[index]['mainCategory'],
                    ));
              });
        },
      ),
    );
  }
}

class SubCategoryList extends StatelessWidget {
  final String? sellectedMainCat;
  final ProductProvider? provider;
  const SubCategoryList({Key? key, this.sellectedMainCat, this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServives _service = FirebaseServives();
    return Dialog(
      child: FutureBuilder<QuerySnapshot>(
        future: _service.subCategories
            .where('mainCategory', isEqualTo: sellectedMainCat)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.size == 0) {
            return const Center(
              child: Text('This Category does not any main categories yet'),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () {
                      provider!.getFormData(
                          subCategory: snapshot.data!.docs[index]
                              ['subCatName']);
                      Navigator.pop(context);
                    },
                    title: Text(
                      snapshot.data!.docs[index]['subCatName'],
                    ));
              });
        },
      ),
    );
  }
}

// i would like to add also the percentage the company will receive for this particular product 
// wether by its category, subcategory or main category or by price