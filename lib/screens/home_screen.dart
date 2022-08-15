import 'package:flutter/material.dart';
import 'package:multivendor_vendor_app/provider/vendor_provider.dart';
import 'package:multivendor_vendor_app/widget/custom_drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _vendorData = Provider.of<VendorProvider>(context);
    if (_vendorData.doc == null) {
      _vendorData.getVendorData();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor App'),
      ),
      drawer: CustomDrawer(),
      body: const Center(child: Text('Dashboard')),
    );
  }
}
