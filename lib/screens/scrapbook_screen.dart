import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scraphive/models/image_info.dart';
import 'package:scraphive/screens/add_text_screen.dart';
import 'package:scraphive/utils/colors.dart';
import 'package:scraphive/utils/utils.dart';
import 'package:scraphive/widgets/hexagon_icon.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:screenshot/screenshot.dart';
import 'dart:math';

ScreenshotController screenshotController = ScreenshotController();

class ScrapbookScreen extends StatefulWidget {
  const ScrapbookScreen({Key? key}) : super(key: key);

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
          (currentImage.rotation ?? 0) + (degrees * (3.14 / 180));
    });
  }

  void changetransparency(int index, double newtransparency) {
    setState(() {
      images[index].transparency = newtransparency;
    });
  }

  void removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  void bringToFront(int index) {
    setState(() {
      final tappedImage = images.removeAt(index);
      images.add(tappedImage);
    });
  }

  void bringToBack(int index) {
    setState(() {
      final selectedImage = images.removeAt(index);
      images.insert(0, selectedImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          color: whiteColor,
          child: Stack(
            children: [
              if (images.isEmpty)
                const Center(
                  child: Text(
                    'Tap add button to start scrapbooking',
                    style: TextStyle(color: greyColor),
                  ),
                ),
              ...images.asMap().entries.map((entry) {
                final index = entry.key;
                final image = entry.value;

                return Positioned(
                  top: image.top,
                  left: image.left,
                  child: Draggable(
                    feedback: ImageClassWidget(image),
                    child: GestureDetector(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Remove Image?'),
                              content: const Text(
                                'Do you want to remove this image?',
                                style: TextStyle(color: brownColor),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: greyColor),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text(
                                    'Remove',
                                    style: TextStyle(color: amberColor),
                                  ),
                                  onPressed: () {
                                    removeImage(index);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Center(child: Text('Adjust Image')),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Tooltip(
                                        message: 'Rotate 15° Clockwise',
                                        child: IconButton(
                                          onPressed: () {
                                            rotateImage(index, 15);
                                          },
                                          icon: const Icon(Icons.rotate_right,
                                              color: amberColor),
                                        ),
                                      ),
                                      Tooltip(
                                        message: 'Rotate 15° Anticlockwise',
                                        child: IconButton(
                                          onPressed: () {
                                            rotateImage(index, -15);
                                          },
                                          icon: const Icon(Icons.rotate_left,
                                              color: greenColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Tooltip(
                                        message: 'Increase Size',
                                        child: IconButton(
                                          onPressed: () {
                                            adjustSize(index, image.width * 1.2,
                                                image.height * 1.2);
                                          },
                                          icon: const Icon(Icons.zoom_in,
                                              color: amberColor),
                                        ),
                                      ),
                                      Tooltip(
                                        message: 'Decrease Size',
                                        child: IconButton(
                                          onPressed: () {
                                            adjustSize(index, image.width * 0.8,
                                                image.height * 0.8);
                                          },
                                          icon: const Icon(Icons.zoom_out,
                                              color: greenColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Tooltip(
                                        message: 'To the Front',
                                        child: IconButton(
                                          onPressed: () {
                                            bringToFront(index);
                                          },
                                          icon: const Icon(Icons.arrow_upward,
                                              color: amberColor),
                                        ),
                                      ),
                                      Tooltip(
                                        message: 'To the Back',
                                        child: IconButton(
                                          onPressed: () {
                                            bringToBack(index);
                                          },
                                          icon: const Icon(Icons.arrow_downward,
                                              color: greenColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Tooltip(
                                    message: 'Change Transparency',
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.opacity,
                                          color: peachColor,
                                        ),
                                        StatefulBuilder(
                                          builder: (context, state) {
                                            return SliderTheme(
                                              data: SliderThemeData(
                                                overlayColor:
                                                    Colors.transparent,
                                                activeTrackColor:
                                                    amberColor.withOpacity(0.7),
                                                inactiveTrackColor: yellowColor,
                                                thumbColor: amberColor,
                                                thumbShape:
                                                    HexagonSliderThumbShape(),
                                                activeTickMarkColor:
                                                    Colors.transparent,
                                                inactiveTickMarkColor:
                                                    Colors.transparent,
                                              ),
                                              child: Slider(
                                                value: image.transparency,
                                                onChanged: (newtransparency) {
                                                  changetransparency(
                                                      index, newtransparency);
                                                  state(() {});
                                                },
                                                min: 0.0,
                                                max: 1.0,
                                                divisions: 10,
                                                label:
                                                    'Transparency: ${(image.transparency * 100).toStringAsFixed(0)}%',
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
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
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            highlightElevation: 0,
            onPressed: _pickImage,
            child: const HexagonIcon(
              icon: EvaIcons.plus,
              fillColor: amberColor,
              iconColor: whiteColor,
              iconSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => saveToGallery(context),
            backgroundColor: Colors.transparent,
            elevation: 0,
            highlightElevation: 0,
            child: const HexagonIcon(
              icon: EvaIcons.save,
              fillColor: greenColor,
              iconColor: whiteColor,
              iconSize: 20,
            ),
          ),
          const SizedBox(height: 16),
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            highlightElevation: 0,
            child: const HexagonIcon(
              icon: EvaIcons.text,
              fillColor: peachColor,
              iconColor: whiteColor,
              iconSize: 18,
            ),
          ),
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

class HexagonSliderThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size.fromRadius(12);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    const double radius = 12;
    final double sideLength = radius * sqrt(3);
    final double centerX = center.dx;
    final double centerY = center.dy;

    final Paint paint = Paint()..color = sliderTheme.thumbColor!;

    final Path path = Path()
      ..moveTo(centerX, centerY - radius)
      ..lineTo(centerX + sideLength / 2, centerY - radius / 2)
      ..lineTo(centerX + sideLength / 2, centerY + radius / 2)
      ..lineTo(centerX, centerY + radius)
      ..lineTo(centerX - sideLength / 2, centerY + radius / 2)
      ..lineTo(centerX - sideLength / 2, centerY - radius / 2)
      ..close();

    canvas.drawPath(path, paint);
  }
}
