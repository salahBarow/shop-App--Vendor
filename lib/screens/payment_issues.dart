import 'package:flutter/material.dart';

class HasNotPaid extends StatelessWidget {
  const HasNotPaid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child:
            Text('You have not Paid for this Month, Please to pay to continue'),
      ),
    );
  }
}
