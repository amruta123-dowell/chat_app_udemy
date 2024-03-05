import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) onPickImage; 
  const UserImagePicker({super.key, required this.onPickImage});
  
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _imageFile;

  void _pickFile() async {
    final tempFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 200, imageQuality: 50);
    if (tempFile == null) {
      return;
    }
    setState(() {
      _imageFile = File(tempFile.path);
    });
    widget.onPickImage(_imageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
        ),
        const SizedBox(
          height: 7,
        ),
        TextButton.icon(
          onPressed: _pickFile,
          label: const Text("Add image"),
          icon: const Icon(Icons.image),
        )
      ],
    );
  }
}
