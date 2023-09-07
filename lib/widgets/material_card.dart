import 'package:flutter/material.dart';

class MaterialCard extends StatelessWidget {
  final Map<String, dynamic> snap;
   final VoidCallback onEdit;

 MaterialCard({required this.snap, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final String description = snap['description'];
    final String username = snap['username'];
    final String materialsUrl = snap['materialsUrl'];

    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(
            materialsUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200.0,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                 TextButton(
                  onPressed: onEdit, // Call the onEdit callback
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.blue, // Customize button text color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
