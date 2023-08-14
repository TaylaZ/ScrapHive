import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:scraphive/utils/colors.dart';

Future<bool> requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: brownColor,
        ),
      ),
      backgroundColor: yellowColor,
      // behavior: SnackBarBehavior.floating,
      // width: 200,
    ),
  );
}
