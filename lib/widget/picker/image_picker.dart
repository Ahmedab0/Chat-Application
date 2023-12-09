import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImg extends StatefulWidget {
  final Function(File pickedImage) onPickedImage;

  const PickImg({super.key, required this.onPickedImage});


  @override
  State<PickImg> createState() => _PickImgState();
}

class _PickImgState extends State<PickImg> {
  File? _pickedImageFile;

  Future takeUserImg(ImageSource src) async {
    final ImagePicker picker = ImagePicker();

    XFile? pickedImage = await picker.pickImage(source: src,imageQuality: 50,maxWidth: 150);

    if (pickedImage == null) {
      return;
    } else {
      setState(() {
        _pickedImageFile = File(pickedImage.path);
      });
      widget.onPickedImage(_pickedImageFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton.icon(
          onPressed: () async => await takeUserImg(ImageSource.gallery),
          icon: const Icon(Icons.photo),
          label: const Text('Gallery'),
        ),

        Expanded(
          child: Container(
            padding: const EdgeInsets.all(3),
            child: CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.grey[400],
              backgroundImage:
              _pickedImageFile == null ? null : FileImage(_pickedImageFile!),
            ),
          ),
        ),

        TextButton.icon(
          onPressed: () async => await takeUserImg(ImageSource.camera),
          icon: const Icon(Icons.camera_alt_outlined),
          label: const Text('Camera'),
        ),
      ],
    );
  }
}
