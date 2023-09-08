import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scraphive/utils/colors.dart';
import 'package:scraphive/widgets/hexagon_avatar.dart';
import 'package:scraphive/widgets/hexagon_slider.dart';

class MaterialCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  final double likes;
  final VoidCallback onEdit;
  final ValueChanged<double> onLikesChanged;

  MaterialCard({
    required this.snap,
    required this.likes,
    required this.onEdit,
    required this.onLikesChanged,
  });

  @override
  State<MaterialCard> createState() => _MaterialCardState();
}

class _MaterialCardState extends State<MaterialCard> {
  double sliderValue = 100;

  @override
  void initState() {
    super.initState();
    sliderValue = widget.likes;
  }

  @override
  Widget build(BuildContext context) {
    final String description = widget.snap['description'];
    final String materialsUrl = widget.snap['materialsUrl'];

    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: EdgeInsets.only(top: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                HexagonAvatar(
                  radius: 32,
                  image: NetworkImage(materialsUrl.toString()),
                ),
                SizedBox(width: 12.0),
                Text(
                  '${description} left ',
                  style: TextStyle(fontSize: 16, color: brownColor),
                ),
                Text(
                  '${sliderValue.toStringAsFixed(0)}%',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: amberColor),
                ),
                Spacer(),
                IconButton(
                  onPressed: widget.onEdit,
                  icon: Icon(
                    EvaIcons.edit2Outline,
                    color: peachColor,
                  ),
                ),
              ],
            ),
            CustomSlider(
              value: sliderValue,
              onChanged: (newValue) {
                setState(() {
                  sliderValue = newValue;
                });
                widget.onLikesChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}
