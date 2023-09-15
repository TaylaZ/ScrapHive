import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:scraphive/utils/colors.dart';

class ScrapHiveScreen extends StatelessWidget {
  const ScrapHiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        centerTitle: false,
        title: const Text(
          'About ScrapHive',
          style: TextStyle(
            color: amberColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: whiteColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'About Us - ScrapHive',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: amberColor,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'At ScrapHive, we\'re on a mission to transform the way you preserve and share your most cherished memories. Our name, a fusion of "scrapbook" and "hive," perfectly encapsulates our purpose: to provide you with a dynamic and collaborative platform where you can collect, create, and curate your scrapbook treasures.',
                style:
                    TextStyle(fontSize: 16.0, color: brownColor, height: 1.5),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Our Story',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: amberColor,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'The idea for ScrapHive was born out of a deep appreciation for the art of scrapbooking and the desire to bring it into the digital age. We understand the sentimental value of every ticket stub, photograph, note, and memento you collect over time. These are more than just physical items; they\'re pieces of your life\'s tapestry, each with a story to tell.',
                style:
                    TextStyle(fontSize: 16.0, color: brownColor, height: 1.5),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'What We Offer',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: amberColor,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'ScrapHive is more than just a digital scrapbooking tool; it\'s a vibrant community of individuals who share your passion for preserving memories...',
                style:
                    TextStyle(fontSize: 16.0, color: brownColor, height: 1.5),
              ),
              const SizedBox(height: 20.0),
              const SizedBox(height: 16.0),
              const Text(
                'How to Use ScrapHive',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: amberColor,
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: const <Widget>[
                  Icon(EvaIcons.home, color: amberColor),
                  SizedBox(width: 8.0),
                  Text(
                    'Home Page',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: brownColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'View posts from others, like, comment, and share them.',
                    style: TextStyle(
                        fontSize: 16.0, color: brownColor, height: 1.5),
                  ),
                  const Text(
                    'Post your scrapbook by tapping the plus button.',
                    style: TextStyle(
                        fontSize: 16.0, color: brownColor, height: 1.5),
                  ),
                  const Icon(Icons.add),
                  const Text(
                    'Search and follow other users by tapping the search button.',
                    style: TextStyle(
                        fontSize: 16.0, color: brownColor, height: 1.5),
                  ),
                  Icon(Icons.search),
                  SizedBox(height: 16.0),
                  Image.asset(
                    'assets/ScrapHive_Homepage.png',
                    height: 300,
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: const <Widget>[
                  Icon(EvaIcons.heart, color: amberColor),
                  SizedBox(width: 8.0),
                  Text(
                    'Liked Page',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: brownColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'View all the posts you have liked for inspiration.',
                    style: TextStyle(
                        fontSize: 16.0, color: brownColor, height: 1.5),
                  ),
                  const SizedBox(height: 16.0),
                  Image.asset(
                    'assets/ScrapHive_Likedpage.png',
                    height: 300,
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: const <Widget>[
                  Icon(FluentIcons.hexagon_three_24_filled, color: amberColor),
                  SizedBox(width: 8.0),
                  Text(
                    'Scrapbook Page',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: brownColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Add images to your scrapbook and adjust their properties.',
                    style: TextStyle(
                        fontSize: 16.0, color: brownColor, height: 1.5),
                  ),
                  const SizedBox(height: 16.0),
                  Image.asset(
                    'assets/ScrapHive_Scrapbookpage.png',
                    height: 300,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Add and edit text with various customization options.',
                    style: TextStyle(
                        fontSize: 16.0, color: brownColor, height: 1.5),
                  ),
                  Row(
                    children: const <Widget>[
                      Icon(
                        EvaIcons.textOutline,
                        size: 24.0,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Customize Text',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: brownColor,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text(
                        'To Create a Virtual Scrapbook:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: brownColor,
                          height: 1.5,
                        ),
                      ),
                      const Text(
                        '1. Tap the save button to add an image onto the screen.',
                        style: TextStyle(
                            fontSize: 16.0, color: brownColor, height: 1.5),
                      ),
                      const Text(
                        '2. Tap on an image to control its size, rotation, order, and transparency.',
                        style: TextStyle(
                            fontSize: 16.0, color: brownColor, height: 1.5),
                      ),
                      const Text(
                        '3. You can freely move images around and add new ones.',
                        style: TextStyle(
                            fontSize: 16.0, color: brownColor, height: 1.5),
                      ),
                      const SizedBox(height: 16.0),
                      Image.asset(
                        'assets/ScrapHive_ScrapbookEditpage.png',
                        height: 300,
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        '4. When you\'re finished, tap the save button.',
                        style: TextStyle(
                            fontSize: 16.0, color: brownColor, height: 1.5),
                      ),
                      const Text(
                        'To Add Text:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: brownColor,
                          height: 1.5,
                        ),
                      ),
                      const Text(
                        '1. Tap on the text button and select an image to add text to.',
                        style: TextStyle(
                            fontSize: 16.0, color: brownColor, height: 1.5),
                      ),
                      const Text(
                        '2. In the text editor, you can:',
                        style: TextStyle(
                            fontSize: 16.0, color: brownColor, height: 1.5),
                      ),
                      const Text(
                        '- Add text by tapping the plus button.',
                        style: TextStyle(
                            fontSize: 16.0, color: brownColor, height: 1.5),
                      ),
                      const Text(
                        '- Adjust bold, underline, italic, size, color, transparency, and rotation of text.',
                        style: TextStyle(
                            fontSize: 16.0, color: brownColor, height: 1.5),
                      ),
                      const Text(
                        '3. Tap the save button to save your work.',
                        style: TextStyle(
                            fontSize: 16.0, color: brownColor, height: 1.5),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: const <Widget>[
                          Icon(EvaIcons.archive, color: amberColor),
                          SizedBox(width: 8.0),
                          Text(
                            'Materials Page',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: brownColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Text(
                            'Efficiently manage your materials with descriptions and percentages.',
                            style: TextStyle(
                                fontSize: 16.0, color: brownColor, height: 1.5),
                          ),
                          const SizedBox(height: 16.0),
                          Image.asset(
                            'assets/ScrapHive_Materialspage.png',
                            height: 300,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: const <Widget>[
                          Icon(EvaIcons.person, color: amberColor),
                          SizedBox(width: 8.0),
                          Text(
                            'Profile Page',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: brownColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Text(
                            'View all your posts, followers, and following numbers.\n'
                            'Discover creative ideas or sign out from the menu.',
                            style: TextStyle(
                                fontSize: 16.0, color: brownColor, height: 1.5),
                          ),
                          const SizedBox(height: 16.0),
                          Image.asset(
                            'assets/ScrapHive_Profilepage.png',
                            height: 300,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
