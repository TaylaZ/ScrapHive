import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scraphive/utils/colors.dart';

class MaterialCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  final double likes;
  final VoidCallback onEdit;

  MaterialCard({required this.snap, required this.likes, required this.onEdit});

  @override
  State<MaterialCard> createState() => _MaterialCardState();
}

class _MaterialCardState extends State<MaterialCard> {
  double sliderValue = 100;

  @override
  void initState() {
    super.initState();
    sliderValue = widget.likes; // Use likes as the initial value
  }

  @override
  Widget build(BuildContext context) {
    final String description = widget.snap['description'];
    final String materialsUrl = widget.snap['materialsUrl'];

    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(materialsUrl.toString()),
                ),
                SizedBox(width: 8.0),
                Transform.translate(
                  offset: Offset(0, 20),
                  child: Text(
                    description,
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: widget.onEdit,
                  icon: Icon(
                    EvaIcons.editOutline,
                    color: greenColor,
                  ),
                ),
              ],
            ),
            Slider(
              value: sliderValue,
              min: 0,
              max: 100,
              onChanged: (newValue) {
                setState(() {
                  sliderValue = newValue;
                });
              },
            ),
            Text(
              '${description} left ${sliderValue.toStringAsFixed(0)}%', // Display the current slider value
              style: TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}
