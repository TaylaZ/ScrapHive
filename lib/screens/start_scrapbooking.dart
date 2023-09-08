import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scraphive/utils/colors.dart';

class StartScrapbooking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        centerTitle: false,
        title: Text(
          'Start Scrapbooking',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('📚 What is Scrapbooking?'),
            _buildPoint(
                'Scrapbooking is a creative hobby where you preserve memories and stories using photos, memorabilia, and decorative elements in a visually appealing way.'),
            SizedBox(height: 16.0),
            _buildSectionTitle('🎨 How to Start with Scrapbooking?'),
            _buildPoint(
                '1. Gather your photos, mementos, and materials like papers, stickers, and embellishments.'),
            _buildPoint(
                '2. Choose a theme or event for your scrapbook (e.g., vacation, wedding, family, hobbies).'),
            _buildPoint(
                '3. Arrange your items on pages, considering layouts and designs.'),
            _buildPoint(
                '4. Use adhesives to secure items, add captions, and decorate with embellishments.'),
            _buildPoint(
                '5. Get creative! Experiment with colors, textures, and styles that express your personality.'),
            SizedBox(height: 16.0),
            _buildSectionTitle('🌟 Why Scrapbooking is a Great Hobby?'),
            _buildPoint(
                '✨ It allows you to relive cherished moments and share stories with others.'),
            _buildPoint(
                '✨ Boosts creativity by combining design and storytelling.'),
            _buildPoint(
                '✨ Provides a sense of accomplishment as you complete beautiful projects.'),
            SizedBox(height: 16.0),
            _buildSectionTitle('💻 Digital Scrapbooking'),
            _buildPoint(
                'Consider digital scrapbooking for convenience and easy storage:'),
            _buildPoint(
                '📱 Digital scrapbooks can be stored on your devices or in the cloud, saving physical space.'),
            _buildPoint(
                '💾 They are easily shareable with friends and family.'),
            _buildPoint(
                '🖼️ Digital tools offer endless design possibilities.'),
            _buildPoint('💡 Try our app, ScrapHive, for digital scrapbooking!'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•', style: TextStyle(fontSize: 20)),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
