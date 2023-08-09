import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final List followers;
  final List following;
  final String password;

  const User({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.followers,
    required this.following,
    required this.password,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      password: snapshot["password"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "followers": followers,
        "following": following,
        "password": password,
      };
}
