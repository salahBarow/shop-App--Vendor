import 'package:flutter/material.dart';
import 'package:multivendor_vendor_app/firebase_service.dart';
import 'package:multivendor_vendor_app/provider/product_provider.dart';
import 'package:provider/provider.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({Key? key}) : super(key: key);

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final FirebaseServives _services = FirebaseServives();
  bool? _manageInvenory = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            _services.formField(
                label: 'SKU',
                type: TextInputType.text,
                onChanged: (value) {
                  provider.getFormData(sku: value);
                }),
            CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Manage Inventory'),
                value: _manageInvenory,
                onChanged: (value) {
                  setState(() {
                    _manageInvenory = value;
                    provider.getFormData(manageInventory: value);
                  });
                }),
            if (_manageInvenory == true)
              Column(
                children: [
                  _services.formField(
                      label: 'Stock Available',
                      type: TextInputType.number,
                      onChanged: (value) {
                        provider.getFormData(invenAvailable: int.parse(value));
                      }),
                  _services.formField(
                      label: 'Re-Order Level',
                      type: TextInputType.number,
                      onChanged: (value) {
                        provider.getFormData(reOrderLevel: int.parse(value));
                      }),
                ],
              )
          ],
        ),
      );
    });
  }
}
