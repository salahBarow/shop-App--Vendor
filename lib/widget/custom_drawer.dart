import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multivendor_vendor_app/provider/vendor_provider.dart';
import 'package:multivendor_vendor_app/screens/add_product_screen.dart';
import 'package:multivendor_vendor_app/screens/home_screen.dart';
import 'package:multivendor_vendor_app/screens/login_screen.dart';
import 'package:multivendor_vendor_app/screens/product_screen.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _vendorData = Provider.of<VendorProvider>(context);

    Widget _drawerMenu({String? title, String? route, IconData? icon}) {
      return ListTile(
        leading: Icon(
          icon,
          color: Colors.blue,
        ),
        title: Text(title!),
        onTap: () {
          Navigator.pushReplacementNamed(context, route!);
        },
      );
    }

    return Drawer(
      child: Column(
        children: [
          Container(
              height: 100,
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DrawerHeader(
                      child: _vendorData.doc == null
                          ? const CircularProgressIndicator()
                          : Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(_vendorData.doc!['logo']),
                                  backgroundColor: Colors.white,
                                  radius: 20.0,
                                  // child: CachedNetworkImage(
                                  //   height: 50,
                                  //   imageUrl: _vendorData.doc!['logo'],
                                  //   fit: BoxFit.fill,
                                  // ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(_vendorData.doc!['businessName']),
                              ],
                            )),
                ],
              )),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                _drawerMenu(
                    icon: Icons.home_filled,
                    title: 'Home',
                    route: HomeScreen.id),
                ExpansionTile(
                  leading: const Icon(Icons.manage_search),
                  title: const Text('Products'),
                  children: [
                    _drawerMenu(title: 'All Product', route: ProductScreen.id),
                    _drawerMenu(
                        title: 'Add Product', route: AddProductScreen.id),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Sign Out'),
            trailing: const Icon(Icons.exit_to_app),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            },
          )
        ],
      ),
    );
  }
}
