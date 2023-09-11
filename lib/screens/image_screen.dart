import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scraphive/utils/colors.dart';
import 'package:scraphive/utils/utils.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:screenshot/screenshot.dart';

class ImageText {
  File imageFile;
  double top;
  double left;
  double width;
  double height;

  ImageText({
    required this.imageFile,
    this.top = 0,
    this.left = 0,
    this.width = 100,
    this.height = 100,
  });
}

ScreenshotController screenshotController = ScreenshotController();

class ScrapbookScreen extends StatefulWidget {
  @override
  _ScrapbookScreenState createState() => _ScrapbookScreenState();
}

class _ScrapbookScreenState extends State<ScrapbookScreen> {
  List<ImageText> images = [];

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final decodedImage =
          await decodeImageFromList(imageFile.readAsBytesSync());

      // Calculate the width and height based on screen height
      final screenHeight = MediaQuery.of(context).size.height;
      final scaleFactor = screenHeight / decodedImage.height;

      setState(() {
        images.add(ImageText(
          imageFile: imageFile,
          width: decodedImage.width.toDouble() * scaleFactor * 0.5,
          height: screenHeight * 0.5,
        ));
      });
    }
  }

  saveToGallery(BuildContext context) {
    screenshotController.capture().then((Uint8List? image) {
      saveImage(image!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image saved'),
        ),
      );
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

  void adjustSize(int index, double newWidth, double newHeight) {
    setState(() {
      images[index].width = newWidth;
      images[index].height = newHeight;
    });
  }

  void onDragEnd(int index, double top, double left) {
    setState(() {
      images[index].top = top;
      images[index].left = left;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          color: primaryColor,
          child: Stack(
            children: images.asMap().entries.map((entry) {
              final index = entry.key;
              final image = entry.value;

              return Positioned(
                top: image.top,
                left: image.left,
                child: Draggable(
                  feedback: ImageTextWidget(image),
                  child: GestureDetector(
                    onDoubleTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Adjust Size'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    adjustSize(index, image.width * 1.2,
                                        image.height * 1.2);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Increase Size'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    adjustSize(index, image.width * 0.8,
                                        image.height * 0.8);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Decrease Size'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: ImageTextWidget(image),
                  ),
                  onDragEnd: (details) {
                    onDragEnd(index, details.offset.dy, details.offset.dx);
                  },
                  childWhenDragging: Container(),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _pickImage,
            child: Icon(Icons.add),
          ),
          SizedBox(height: 16), // Add some spacing between the buttons
          FloatingActionButton(
            onPressed: () => saveToGallery(context),
            child: Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}

class ImageTextWidget extends StatelessWidget {
  final ImageText image;

  ImageTextWidget(this.image);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        image.top += details.delta.dy;
        image.left += details.delta.dx;
      },
      child: Container(
        width: image.width,
        height: image.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(image.imageFile),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
