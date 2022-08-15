import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic>? productInfo = {};

  getFormData({
    String? productName,
    int? price,
    int? salePrice,
    String? category,
    String? subCategory,
    String? mainCategory,
    DateTime? schedule,
    String? sku,
    bool? manageInventory,
    int? invenAvailable,
    int? reOrderLevel,
    String? brand,
    List? size,
    List? color,
    int? minSold,
  }) {
    if (productName != null) {
      productInfo!['productName'] = productName;
    }
    if (price != null) {
      productInfo!['price'] = price;
    }
    if (salePrice != null) {
      productInfo!['salePrice'] = salePrice;
    }
    if (category != null) {
      productInfo!['category'] = category;
    }
    if (subCategory != null) {
      productInfo!['subCategory'] = subCategory;
    }
    if (mainCategory != null) {
      productInfo!['mainCategory'] = mainCategory;
    }
    if (schedule != null) {
      productInfo!['schedule'] = schedule;
    }
    if (sku != null) {
      productInfo!['sku'] = sku;
    }
    if (manageInventory != null) {
      productInfo!['manageInventory'] = manageInventory;
    }
    if (invenAvailable != null) {
      productInfo!['invenAvailable'] = invenAvailable;
    }
    if (reOrderLevel != null) {
      productInfo!['reOrderLevel'] = reOrderLevel;
    }
    if (brand != null) {
      productInfo!['brand'] = brand;
    }
    if (size != null) {
      productInfo!['size'] = size;
    }
    if (color != null) {
      productInfo!['color'] = color;
    }
    if (minSold != null) {
      productInfo!['minSold'] = minSold;
    }

    notifyListeners();
  }
}
