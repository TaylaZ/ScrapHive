import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scraphive/utils/colors.dart';
import 'package:scraphive/widgets/hexagon_avatar.dart';
import 'package:scraphive/widgets/hexagon_slider.dart';

class MaterialCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  final double percentage;
  final VoidCallback onEdit;
  final ValueChanged<double> onpercentageChanged;

  MaterialCard({
    required this.snap,
    required this.percentage,
    required this.onEdit,
    required this.onpercentageChanged,
  });

  @override
  State<MaterialCard> createState() => _MaterialCardState();
}

class _MaterialCardState extends State<MaterialCard> {
  double sliderValue = 100;

  @override
  void initState() {
    super.initState();
    sliderValue = widget.percentage;
  }

  @override
  Widget build(BuildContext context) {
    final String description = widget.snap['description'];
    final String materialsUrl = widget.snap['materialsUrl'];

    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(widget.snap['materialsId']), 
      background: Container(
        color: greenColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(
          Icons.delete,
          color: yellowColor,
        ),
      ),
      confirmDismiss: (direction) async {
        bool confirmDelete = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Delete Material"),
              content: const Text("Are you sure you want to delete this material?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: greyColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // User confirmed the delete operation.
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: amberColor),
                  ),
                ),
              ],
            );
          },
        );

        return confirmDelete == true;
      },
      onDismissed: (direction) {
        FirebaseFirestore.instance
            .collection('materials')
            .doc(widget.snap['materialsId'])
            .delete()
            .then((_) {})
            .catchError((error) {
          print("Error deleting material: $error");
        });
      },
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16),
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
                    '${description} ',
                    style: const  TextStyle(fontSize: 16, color: brownColor),
                  ),
                  Text(
                    '${sliderValue.toStringAsFixed(0)}%',
                    style:  const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: amberColor),
                  ),
                  const  Spacer(),
                  IconButton(
                    onPressed: widget.onEdit,
                    icon:  const Icon(
                      EvaIcons.edit2Outline,
                      color: peachColor,
                    ),
                  ),
                ],
              ),
              HexagonSlider(
                value: sliderValue,
                onChanged: (newValue) {
                  setState(() {
                    sliderValue = newValue;
                  });
                  widget.onpercentageChanged(newValue);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
