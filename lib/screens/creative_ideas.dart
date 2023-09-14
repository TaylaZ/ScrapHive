import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scraphive/utils/colors.dart';

class ScrapbookingIdeasScreen extends StatelessWidget {
  const ScrapbookingIdeasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        centerTitle: false,
        title: const Text(
          'Creative Ideas',
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
      body: ListView(
        children: [
          _buildIdeaCard(
            'Study Notes Masterpiece',
            'Create a study notes scrapbook to make learning more engaging. Select colorful papers, highlight important points, and use sticky notes for annotations. Add diagrams and mind maps to visualize concepts.',
            'assets/study.jpg',
          ),
          _buildIdeaCard(
            'TV Show Appreciation',
            'Craft a scrapbook dedicated to your favorite TV show. Choose stills from memorable episodes, include quotes, and write your reactions. Use themed stickers and washi tape to enhance the pages.',
            'assets/TV.png',
          ),
          _buildIdeaCard(
            'Artwork Showcase',
            'Compile a scrapbook of your artwork journey. Add sketches, paintings, and mixed media pieces. Use pockets or sleeves for delicate pieces. Include notes on techniques and inspirations.',
            'assets/artwork.jpg',
          ),
          _buildIdeaCard(
            'Gardening Journal',
            'Document your gardening journey in a scrapbook. Capture the growth of plants, seasonal changes, and successful harvests. Attach seed packets and labels for reference.',
            'assets/garden.png',
          ),
          _buildIdeaCard(
            'Recipe Collection',
            'Create a culinary scrapbook with your favorite recipes. Attach photos of the dishes, ingredient lists, and personal tips. Decorate with kitchen-themed embellishments.',
            'assets/recipe.jpg',
          ),
          _buildIdeaCard(
            'Travel Bucket List',
            'Design a scrapbook to plan and document your dream travel destinations. Include pictures of the places you wish to visit, travel tips, and budgeting ideas. Add a map to mark your future adventures.',
            'assets/travel.jpg',
          ),
        ],
      ),
    );
  }

  Widget _buildIdeaCard(String title, String description, String imagePath) {
    return Card(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: brownColor,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: brownColor,
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
