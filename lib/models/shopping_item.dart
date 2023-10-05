import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingItem {
  final String description;
  final String uid;
  final price;
  final DateTime datePublished;
  final String shoppingItemId;

  const ShoppingItem(
      {required this.description,
      required this.uid,
      this.price,
      required this.datePublished,
      required this.shoppingItemId});

  static ShoppingItem fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ShoppingItem(
      description: snapshot["description"],
      uid: snapshot["uid"],
      price: snapshot["price"],
      datePublished: snapshot["datePublished"],
      shoppingItemId: snapshot["shoppingItemId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "price": price,
        "datePublished": datePublished,
        "shoppingItemId": shoppingItemId,
      };
}
