import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagesTab extends StatefulWidget {
  const ImagesTab({Key? key}) : super(key: key);

  @override
  State<ImagesTab> createState() => _ImagesTabState();
}

class _ImagesTabState extends State<ImagesTab> {
  final ImagePicker _picker = ImagePicker();
  // the ? after the XFile is added recently as a suggested correction
  Future<List<XFile>?> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    return images;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('General'),
      ),
    );
  }
}
