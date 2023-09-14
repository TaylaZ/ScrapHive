import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:scraphive/utils/colors.dart';

class ScrapHiveScreen extends StatelessWidget {
  final Color whiteColor = Colors.white;
  final Color amberColor = Colors.amber;
  final Color brownColor = Colors.brown;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        centerTitle: false,
        title: Text(
          'Creative Ideas',
          style: TextStyle(
            color: amberColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                EvaIcons.arrowIosBack,
                color: amberColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            StepItem(
              title: 'Home Page',
              description:
                  'View posts, like, comment, and share. Create your own scrapbook.',
              icon: EvaIcons.homeOutline,
              iconColor: Colors.blue,
            ),
            StepItem(
              title: 'Liked Page',
              description:
                  'View posts you liked. Use as inspiration for future scrapbooks.',
              icon: EvaIcons.heartOutline,
              iconColor: Colors.red,
            ),
            StepItem(
              title: 'Scrapbook Page',
              description:
                  'Create and edit scrapbooks. Add images and text with various settings.',
              icon: EvaIcons.imageOutline,
              iconColor: Colors.green,
            ),
            StepItem(
              title: 'Materials Page',
              description:
                  'Manage materials efficiently. Add descriptions and track percentages.',
              icon: EvaIcons.clipboardOutline,
              iconColor: Colors.purple,
            ),
            StepItem(
              title: 'Profile Page',
              description:
                  'View your posts, followers, and following. Access creative ideas.',
              icon: EvaIcons.personOutline,
              iconColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}

class StepItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;

  StepItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
        size: 36.0,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: brownColor,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      subtitle: Text(
        description,
        style: TextStyle(
          color: brownColor,
        ),
      ),
    );
  }
}
