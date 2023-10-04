import 'dart:io';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scraphive/models/text_info.dart';
import 'package:scraphive/utils/colors.dart';
import 'package:scraphive/widgets/edit_text.dart';
import 'package:scraphive/widgets/hexagon_icon.dart';
import 'package:screenshot/screenshot.dart';

class EditImageScreen extends StatefulWidget {
  const EditImageScreen({Key? key, required this.selectedImage})
      : super(key: key);
  final String selectedImage;

  @override
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends EditImageViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          color: whiteColor,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                _selectedImage,
                for (int i = 0; i < texts.length; i++)
                  Positioned(
                    left: texts[i].left,
                    top: texts[i].top,
                    child: GestureDetector(
                      onLongPress: () {
                        showRemoveTextConfirmation(context);
                      },
                      onTap: () => setCurrentIndex(context, i),
                      child: Draggable(
                        feedback: ImageText(
                          textInfo: texts[i],
                        ),
                        child: ImageText(textInfo: texts[i]),
                        onDragEnd: (drag) {
                          final renderBox =
                              context.findRenderObject() as RenderBox;
                          Offset off = renderBox.globalToLocal(drag.offset);
                          setState(() {
                            texts[i].top = off.dy - 80;
                            texts[i].left = off.dx;
                          });
                        },
                      ),
                    ),
                  ),
                creatorText.text.isNotEmpty
                    ? Positioned(
                        left: 0,
                        bottom: 0,
                        child: Text(
                          creatorText.text,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.3)),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => addNewDialog(context),
            backgroundColor: Colors.transparent,
            elevation: 0,
            highlightElevation: 0,
            child: const  HexagonIcon(
              icon: EvaIcons.plus,
              fillColor: amberColor,
              iconColor: whiteColor,
              iconSize: 20,
            ),
          ),
          const  SizedBox(
            height: 16,
          ),
          FloatingActionButton(
            onPressed: () => saveToGallery(context),
            backgroundColor: Colors.transparent,
            elevation: 0,
            highlightElevation: 0,
            child: const  HexagonIcon(
              icon: EvaIcons.save,
              fillColor: greenColor,
              iconColor: whiteColor,
              iconSize: 20,
            ),
          ),
         const   SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget get _selectedImage => Center(
        child: Image.file(
          File(
            widget.selectedImage,
          ),
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
      );

  Future<void> showRemoveTextConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  const Text(
            'Remove Text?',
            style: TextStyle(color: brownColor),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const  <Widget>[
                Text(
                  'Are you sure you want to remove this text?',
                  style: TextStyle(color: brownColor),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  const Text(
                'Cancel',
                style: TextStyle(color: greyColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:  const Text(
                'Remove',
                style: TextStyle(color: amberColor),
              ),
              onPressed: () {
                removeText(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void rotateTextClockwise() {
    setState(() {
      const double radians = 15 * (3.14 / 180);
      texts[currentIndex].rotation += radians;
    });
  }

  void rotateTextCounterClockwise() {
    setState(() {
      const double radians = -15 * (3.14 / 180);
      texts[currentIndex].rotation += radians;
    });
  }

  AppBar get _appBar => AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 40,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Back',
                icon: const Icon(
                  EvaIcons.arrowIosBack,
                  color: amberColor,
                  size: 24,
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                onPressed: increaseFontSize,
                tooltip: 'Increase Font Size',
                icon: const Icon(
                  EvaIcons.plusCircle,
                  color: amberColor,
                  size: 24,
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                onPressed: decreaseFontSize,
                tooltip: 'Decrease Font Size',
                icon: const Icon(
                  EvaIcons.minusCircle,
                  color: amberColor,
                  size: 24,
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                onPressed: boldText,
                tooltip: 'Bold',
                icon: const Icon(
                  Icons.format_bold,
                  color: amberColor,
                  size: 24,
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                onPressed: italicText,
                tooltip: 'Italic',
                icon: const Icon(
                  Icons.format_italic,
                  color: amberColor,
                  size: 24,
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                onPressed: underlineText,
                tooltip: 'Underline',
                icon: const Icon(
                  Icons.format_underlined,
                  color: amberColor,
                  size: 24,
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                onPressed: rotateTextClockwise,
                tooltip: 'Rotate Text Clockwise',
                icon: const Icon(
                  Icons.rotate_right,
                  color: amberColor,
                  size: 24,
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                onPressed: rotateTextCounterClockwise,
                tooltip: 'Rotate Text Counterclockwise',
                icon: const Icon(
                  Icons.rotate_left,
                  color: amberColor,
                  size: 24,
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: Ink(
                decoration: BoxDecoration(
                  border: Border.all(color: color, width: 3.0),
                  color: whiteColor,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => pickColor(context),
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.color_lens,
                      size: 20.0,
                      color: amberColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class ImageText extends StatelessWidget {
  final TextInfo textInfo;

  ImageText({required this.textInfo});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: textInfo.rotation,
      child: Text(
        textInfo.text,
        style: TextStyle(
          color: textInfo.color,
          fontWeight: textInfo.fontWeight,
          fontStyle: textInfo.fontStyle,
          fontSize: textInfo.fontSize,
          decoration: textInfo.textDecoration,
        ),
        textAlign: textInfo.textAlign,
      ),
    );
  }
}
