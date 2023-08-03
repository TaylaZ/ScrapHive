import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scraphive/widgets/edit_image_viewmodel.dart';
import 'package:screenshot/screenshot.dart';
import '../widgets/image_text.dart';

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
        child: SafeArea(
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
                        setState(() {
                          currentIndex = i;
                          removeText(context);
                        });
                      },
                      onTap: () => setCurrentIndex(context, i),
                      child: Draggable(
                        feedback: ImageText(textInfo: texts[i]),
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
      floatingActionButton: _addText,
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

  Widget get _addText => FloatingActionButton(
        onPressed: () => addNewDialog(context),
        backgroundColor: Colors.white,
        tooltip: 'Tap to add text',
        child: const Icon(
          Icons.edit,
          color: Colors.amber,
        ),
      );

  AppBar get _appBar => AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              IconButton(
                onPressed: () => saveToGallery(context),
                tooltip: 'Save Image',
                icon: const Icon(
                  Icons.save,
                  color: Colors.amber,
                ),
              ),
              IconButton(
                onPressed: increaseFontSize,
                tooltip: 'Increase Font Size',
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.amber,
                ),
              ),
              IconButton(
                onPressed: decreaseFontSize,
                tooltip: 'Decrease Font Size',
                icon: const Icon(
                  Icons.remove_circle,
                  color: Colors.amber,
                ),
              ),
              IconButton(
                onPressed: alignLeft,
                tooltip: 'Align Left',
                icon: const Icon(
                  Icons.format_align_left,
                  color: Colors.amber,
                ),
              ),
              IconButton(
                onPressed: alignCenter,
                tooltip: 'Align Center',
                icon: const Icon(
                  Icons.format_align_center,
                  color: Colors.amber,
                ),
              ),
              IconButton(
                onPressed: alignRight,
                tooltip: 'Align Right',
                icon: const Icon(
                  Icons.format_align_right,
                  color: Colors.amber,
                ),
              ),
              IconButton(
                onPressed: boldText,
                tooltip: 'Bold',
                icon: const Icon(
                  Icons.format_bold,
                  color: Colors.amber,
                ),
              ),
              IconButton(
                onPressed: italicText,
                tooltip: 'Italic',
                icon: const Icon(
                  Icons.format_italic,
                  color: Colors.amber,
                ),
              ),
              IconButton(
                onPressed: addLinesToText,
                tooltip: 'Add New Line',
                icon: const Icon(
                  Icons.post_add_sharp,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Ink(
                decoration: BoxDecoration(
                  border: Border.all(color: color, width: 3.0),
                  color: Colors.white,
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
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
              // IconButton(
              //   onPressed: () => pickColor(context),
              //   tooltip: 'Pick Color',
              //   icon: Icon(
              //     Icons.color_lens,
              //     color: color,
              //   ),
              // ),
              // const SizedBox(
              //   width: 20,
              // ),
            ],
          ),
        ),
      );
}
