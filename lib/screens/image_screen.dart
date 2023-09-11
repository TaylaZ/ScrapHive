import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
          width: decodedImage.width.toDouble() * scaleFactor,
          height: screenHeight,
        ));
      });
    }
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
      appBar: AppBar(
        title: Text('Scrapbook'),
      ),
      body: Stack(
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
                onDragEnd(index, details.offset.dy - 80, details.offset.dx);
              },
              childWhenDragging: Container(),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: Icon(Icons.add),
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
