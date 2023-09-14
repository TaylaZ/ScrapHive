import 'package:flutter/material.dart';

class ScrapHiveLoader extends StatelessWidget {
  const ScrapHiveLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/ScrapHive_Loader.gif',
        height: 48,
      ),
    );
  }
}
