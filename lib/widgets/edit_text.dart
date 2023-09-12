import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:scraphive/models/text_info.dart';
import 'package:scraphive/screens/add_text_screen.dart';
import 'package:scraphive/widgets/custom_buttons.dart';
import 'package:screenshot/screenshot.dart';
import '../utils/utils.dart';

abstract class EditImageViewModel extends State<EditImageScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorText = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();

  List<TextInfo> texts = [];
  int currentIndex = 0;

  Color color = Colors.black;
  Widget buildColorPicker() => ColorPicker(
      pickerColor: color,
      onColorChanged: (color) => setState(() {
            this.color = color;
            texts[currentIndex].color = color;
          }));

  void pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick Your Color'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildColorPicker(),
            TextButton(
              child: const Text(
                'SELECT',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  saveToGallery(BuildContext context) {
    screenshotController.capture().then((Uint8List? image) {
      saveImage(image!);
      showSnackBar(context, 'Image Saved!');
    }).catchError((err) => print(err));
  }

  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = "screenshot_$time";
    await requestPermission(Permission.mediaLibrary);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  removeText(BuildContext context) {
    setState(() {
      texts.removeAt(currentIndex);
    });
    showSnackBar(context, 'Text Deleted');
  }

  setCurrentIndex(BuildContext context, index) {
    setState(() {
      currentIndex = index;
      color = texts[currentIndex].color;
    });
    showSnackBar(context, 'Selected for Styling');
  }

  changeTextColor(Color color) {
    setState(() {
      texts[currentIndex].color = color;
    });
  }

  increaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize *= 1.2;
    });
  }

  decreaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize *= 0.8;
    });
  }

  boldText() {
    setState(() {
      if (texts[currentIndex].fontWeight == FontWeight.bold) {
        texts[currentIndex].fontWeight = FontWeight.normal;
      } else {
        texts[currentIndex].fontWeight = FontWeight.bold;
      }
    });
  }

  italicText() {
    setState(() {
      if (texts[currentIndex].fontStyle == FontStyle.italic) {
        texts[currentIndex].fontStyle = FontStyle.normal;
      } else {
        texts[currentIndex].fontStyle = FontStyle.italic;
      }
    });
  }

  underlineText() {
  setState(() {
    if (texts[currentIndex].textDecoration == TextDecoration.underline) {
      texts[currentIndex].textDecoration = TextDecoration.none;
    } else {
      texts[currentIndex].textDecoration = TextDecoration.underline;
    }
  });
}


  addNewText(BuildContext context) {
    setState(() {
      texts.add(
        TextInfo(
          text: textEditingController.text,
          left: 0,
          top: 0,
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          fontSize: 30,
          textAlign: TextAlign.left,
        ),
      );
      Navigator.of(context).pop();
    });
  }

  addNewDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add Text'),
        content: TextField(
          controller: textEditingController,
          maxLength: 100,
          decoration: const InputDecoration(
            suffixIcon: Icon(
              Icons.edit,
            ),
            filled: true,
            hintText: 'Your Text Here',
          ),
        ),
        actions: [
          DefaultButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back'),
              bgColor: Colors.white,
              textColor: Colors.amber),
          DefaultButton(
              onPressed: () => addNewText(context),
              child: const Text('Add Text'),
              bgColor: Colors.amber,
              textColor: Colors.black),
        ],
      ),
    );
  }
}
