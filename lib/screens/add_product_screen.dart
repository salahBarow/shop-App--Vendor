import 'package:flutter/material.dart';
import 'package:multivendor_vendor_app/provider/product_provider.dart';
import 'package:multivendor_vendor_app/widget/add_product/general.dart';
import 'package:multivendor_vendor_app/widget/add_product/images.dart';
import 'package:multivendor_vendor_app/widget/add_product/inventory.dart';
import 'package:multivendor_vendor_app/widget/add_product/linked_product.dart';
import 'package:multivendor_vendor_app/widget/add_product/attribute.dart';
import 'package:multivendor_vendor_app/widget/custom_drawer.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatelessWidget {
  static const String id = 'add product';
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductProvider>(context);
    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: DefaultTabController(
        length: 5,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Product'),
            bottom: const TabBar(
              isScrollable: true,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.deepOrange, width: 4)),
              tabs: [
                Tab(
                  child: Text('General'),
                ),
                Tab(
                  child: Text('Inventory'),
                ),
                Tab(
                  child: Text('Attribute'),
                ),
                Tab(
                  child: Text('Linked Products'),
                ),
                Tab(
                  child: Text('Images'),
                ),
              ],
            ),
          ),
          drawer: const CustomDrawer(),
          body: const TabBarView(children: [
            GeneralTab(),
            InventoryTab(),
            AttributeTab(),
            LinkedProductTab(),
            ImagesTab(),
          ]),
          persistentFooterButtons: [
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
                  print(_provider.productInfo);
                },
                child: const Text('Save Product'))
          ],
        ),
      ),
    );
  }
}
