import 'package:flutter/material.dart';
import 'package:multivendor_vendor_app/widget/custom_drawer.dart';

class ProductScreen extends StatelessWidget {
  static const String id = 'product screen';
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product List'),
        ),
        drawer: CustomDrawer(),
        body: Center(
          child: Text('Product Screen'),
        ));
  }
}
