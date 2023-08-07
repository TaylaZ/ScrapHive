import 'package:flutter/material.dart';

class LoadingImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/ScrapHive_Loader.gif',
        height: 72,
      ),
    );
  }
}
