import 'dart:io';

class ImageClass {
  File imageFile;
  double top;
  double left;
  double width;
  double height;
  double? rotation;
  double transparency;
   bool isFixed = false; 

  ImageClass({
    required this.imageFile,
    this.top = 0,
    this.left = 0,
    this.width = 100,
    this.height = 100,
    this.rotation = 0,
    this.transparency = 0,
    this.isFixed = false,
  });
}
