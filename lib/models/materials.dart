import 'package:cloud_firestore/cloud_firestore.dart';

class Materials {
  final String description;
  final String uid;
  final String materialsName;
  final String materialsImage;

  const Materials({
    required this.description,
    required this.uid,
    required this.materialsName,
    required this.materialsImage,
  });

  static Materials fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Materials(
        description: snapshot["description"],
        uid: snapshot["uid"],
        materialsName: snapshot["materialsName"],
        materialsImage: snapshot['materialsImage']);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "materialsName": materialsName,
        'materialsImage': materialsImage,
      };
}
