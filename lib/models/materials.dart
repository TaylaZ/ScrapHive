import 'package:cloud_firestore/cloud_firestore.dart';

class Materials {
  final String description;
  final String uid;
  final String username;
  final likes;
  final String materialsId;
  final DateTime datePublished;
  final String materialsUrl;
  final String profImage;

  const Materials({
    required this.description,
    required this.uid,
    required this.username,
    required this.likes,
    required this.materialsId,
    required this.datePublished,
    required this.materialsUrl,
    required this.profImage,
  });

  static Materials fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Materials(
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        materialsId: snapshot["materialsId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        materialsUrl: snapshot['materialsUrl'],
        profImage: snapshot['profImage']);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "materialsId": materialsId,
        "datePublished": datePublished,
        'materialsUrl': materialsUrl,
        'profImage': profImage
      };
}
