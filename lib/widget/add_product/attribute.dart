import 'package:flutter/material.dart';
import 'package:multivendor_vendor_app/provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class AttributeTab extends StatefulWidget {
  const AttributeTab({Key? key}) : super(key: key);

  @override
  State<AttributeTab> createState() => _AttributeTabState();
}

class _AttributeTabState extends State<AttributeTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final List<String> _sizeList = [];
  List<String> _colorList = [];
  final _sizeText = TextEditingController();
  final _colorText = TextEditingController();
  bool? _save = false;
  bool _enteredSize = false;
  bool _enteredColor = false;
  final List<String> allVariants = [];

  Widget _formField(
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

  getVariantsTogether() {
    for (var element in _colorList) {
      for (var el in _sizeList) {
        print(element + el);
        return ListView.builder(
            shrinkWrap: true,
            itemCount: element.length,
            itemBuilder: (context, i) {
              return Text(element + el);
            });
        // return Column(
        //   children: [
        //     Row(
        //       children: [
        //         Text('${element.length} ${el.length}'),
        //         // Text(el)
        //       ],
        //     ),
        //   ],
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _formField(
                label: 'Brand',
                type: TextInputType.text,
                onChanged: (value) {
                  provider.getFormData(brand: value);
                }),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: _sizeText,
                  decoration: const InputDecoration(
                    label: Text('Size'),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _enteredSize = true;
                      });
                    }
                  },
                )),
                if (_enteredSize)
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _sizeList.add(_sizeText.text);
                          _sizeText.clear();
                          _enteredSize = false;
                          _save = false;
                        });
                      },
                      child: const Text('Add'))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (_sizeList.isNotEmpty)
              Container(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _sizeList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onLongPress: () {
                            setState(() {
                              _sizeList.removeAt(index);
                              provider.getFormData(size: _sizeList);
                            });
                          },
                          child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: Text(_sizeList[index])),
                              )),
                        ),
                      );
                    }),
              ),
            // const Text('* Long Press to delete'),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: _colorText,
                  decoration: const InputDecoration(
                    label: Text('Color'),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _enteredColor = true;
                      });
                    }
                  },
                )),
                if (_enteredColor)
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _colorList.add(_colorText.text);
                          _colorText.clear();
                          _enteredColor = false;
                          _save = false;
                        });
                      },
                      child: const Text('Add'))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (_colorList.isNotEmpty)
              Container(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _colorList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onLongPress: () {
                            setState(() {
                              _colorList.removeAt(index);
                              provider.getFormData(color: _colorList);
                            });
                          },
                          child: Container(
                              height: 50,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                  _colorList[index],
                                  style: TextStyle(color: Colors.black),
                                )),
                              )),
                        ),
                      );
                    }),
              ),

            if (_sizeList.isNotEmpty && _colorList.isNotEmpty)
              Column(
                children: [
                  const Text('* Long Press to delete'),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          provider.getFormData(size: _sizeList);
                          provider.getFormData(color: _colorList);
                        });
                        _save = true;
                      },
                      child: Text(_save == true ? 'Saved' : 'Save')),
                  getVariantsTogether(),
                ],
              ),
          ],
        ),
      );
    });
  }
}
