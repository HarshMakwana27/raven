import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'dart:io';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onUploadImage});

  final void Function(File uplodedImage) onUploadImage;

  @override
  State<StatefulWidget> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _takePhoto() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxWidth: 150, imageQuality: 100);

    setState(() {
      _pickedImageFile = File(pickedImage!.path);
    });

    widget.onUploadImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        TextButton.icon(
          onPressed: _takePhoto,
          icon: Icon(
            Icons.add_a_photo,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          label: const Text('Add a photo'),
        ),
      ],
    );
  }
}
