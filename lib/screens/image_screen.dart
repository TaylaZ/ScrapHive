import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scraphive/models/image_info.dart';
import 'package:scraphive/screens/edit_image_screen.dart';
import 'package:scraphive/utils/colors.dart';
import 'package:scraphive/utils/utils.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:screenshot/screenshot.dart';

ScreenshotController screenshotController = ScreenshotController();

class ScrapbookScreen extends StatefulWidget {
  @override
  _ScrapbookScreenState createState() => _ScrapbookScreenState();
}

class _ScrapbookScreenState extends State<ScrapbookScreen> {
  List<ImageClass> images = [];

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
        images.add(ImageClass(
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

  void rotateImage(int index, double degrees) {
    final currentImage = images[index];

    setState(() {
      currentImage.rotation =
          (currentImage.rotation ?? 0) + (degrees * (3.14159265359 / 180));
    });
  }

  void changetransparency(int index, double newtransparency) {
    setState(() {
      images[index].transparency = newtransparency;
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
                  feedback: ImageClassWidget(image),
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
                                    rotateImage(index,
                                        15); // Rotate 15 degrees clockwise
                                    Navigator.pop(context);
                                  },
                                  child: Text('Rotate 15° Clockwise'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    rotateImage(index,
                                        -15); // Rotate 15 degrees anticlockwise
                                    Navigator.pop(context);
                                  },
                                  child: Text('Rotate 15° Anticlockwise'),
                                ),
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
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Adjust transparency'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Slider(
                                                value: image.transparency,
                                                onChanged: (newtransparency) {
                                                  changetransparency(
                                                      index, newtransparency);
                                                },
                                                min: 0.0,
                                                max: 1.0,
                                                divisions:
                                                    10, // You can adjust the number of divisions as needed
                                                label:
                                                    'transparency: ${image.transparency.toStringAsFixed(1)}',
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Close the dialog
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Done'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Text('Change transparency'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: ImageClassWidget(image),
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
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => saveToGallery(context),
            child: Icon(Icons.save),
          ),
          FloatingActionButton(
            onPressed: () async {
              XFile? file = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              if (file != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditImageScreen(
                      selectedImage: file.path,
                    ),
                  ),
                );
              }
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class ImageClassWidget extends StatelessWidget {
  final ImageClass image;

  ImageClassWidget(this.image);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        image.top += details.delta.dy;
        image.left += details.delta.dx;
      },
      child: Transform.rotate(
        angle: image.rotation ?? 0,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.transparent.withOpacity(
                1.0 - image.transparency), // Adjust transparency here
            BlendMode.dstIn, // Use dstIn blend mode to make image transparent
          ),
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
        ),
      ),
    );
  }
}
