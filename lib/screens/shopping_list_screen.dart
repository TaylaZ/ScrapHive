import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:scraphive/providers/user_provider.dart';
import 'package:scraphive/resources/firestore_methods.dart';
import 'package:scraphive/utils/colors.dart';
import 'package:scraphive/utils/utils.dart';
import 'package:scraphive/widgets/hexagon_icon.dart';
import 'package:scraphive/widgets/scraphive_loader.dart';
import '../models/shopping_item.dart';
import 'package:uuid/uuid.dart';

import 'package:scraphive/providers/user_provider.dart';

class ShoppingItemListScreen extends StatefulWidget {
  @override
  _ShoppingItemListScreenState createState() => _ShoppingItemListScreenState();
}

class _ShoppingItemListScreenState extends State<ShoppingItemListScreen> {
  bool _isLoading = false;
  double? _priceValue;
  final TextEditingController _descriptionController = TextEditingController();
  late Stream<QuerySnapshot<Map<String, dynamic>>> _stream;
  bool _isAddingItem = false;
  double _totalPriceSum = 0.0;

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return _isAddingItem
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: whiteColor,
              bottomOpacity: 0.0,
              elevation: 0.0,
              leading: IconButton(
                icon: const Icon(EvaIcons.arrowBack),
                color: amberColor,
                onPressed: () {
                  setState(() {
                    _isAddingItem = false;
                  });
                },
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/ScrapHive_Logo.svg',
                    height: 28,
                  ),
                ],
              ),
              centerTitle: true,
              actions: [
                TextButton(
                  onPressed: () {
                    addItem(
                      userProvider.getUser.uid,
                    );
                    _descriptionController.clear();
                  },
                  child: const Text(
                    'Add Item',
                    style: TextStyle(
                      color: amberColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _isLoading
                      ? const ScrapHiveLoader()
                      : const Padding(
                          padding: EdgeInsets.only(
                            top: 0,
                          ),
                        ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                              hintText: "Description of Item...",
                              border: InputBorder.none),
                          maxLength: 30,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _priceValue = double.tryParse(value);
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: "How much is it?",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: whiteColor,
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
              title: const Text(
                'Shopping List',
                style: TextStyle(
                  color: amberColor,
                ),
              ),
              centerTitle: false,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isAddingItem = true;
                });
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              highlightElevation: 0,
              child: const HexagonIcon(
                icon: EvaIcons.plus,
                fillColor: amberColor,
                iconColor: whiteColor,
                iconSize: 20,
              ),
            ),
            body: Container(
              color: whiteColor,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('shoppingItems')
                    .where('uid',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No shopping items available.'),
                    );
                  }

                  return _buildShoppingItemList(snapshot.data!);
                },
              ),
            ),
          );
  }

  Widget _buildShoppingItemList(QuerySnapshot snapshot) {
    final shoppingItems = snapshot.docs;

    double totalSum = shoppingItems
        .map((doc) => (doc.data() as Map<String, dynamic>)['price'] as double)
        .fold(0.0, (prev, price) => prev + price);

    return ListView.builder(
      itemCount: shoppingItems.length + 1,
      itemBuilder: (context, index) {
        if (index < shoppingItems.length) {
          final shoppingItem =
              shoppingItems[index].data() as Map<String, dynamic>;
          final description = shoppingItem['description'];
          final price = shoppingItem['price'];
          final shoppingItemId = shoppingItems[index].id;

          return Dismissible(
            key: Key(shoppingItemId),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteItem(shoppingItemId);
            },
            background: Container(
              alignment: Alignment.centerRight,
              color: greenColor,
              child: Icon(
                Icons.delete,
                color: whiteColor,
              ),
            ),
            child: ListTile(
              title: Text(
                description,
                style: const TextStyle(fontSize: 16, color: brownColor),
              ),
              subtitle: Text(
                'Price: \$${price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14, color: greyColor),
              ),
              trailing: IconButton(
                icon: Icon(
                  EvaIcons.edit2Outline,
                  color: amberColor,
                ),
                onPressed: () {
                  _editItemDescription(shoppingItemId, description, price);
                },
              ),
            ),
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total Estimated Sum: ',
                  style: TextStyle(color: brownColor, fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '\$${totalSum.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: greenColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  void addItem(
    String uid,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FireStoreMethods()
          .uploadShoppingItem(_descriptionController.text, uid, _priceValue);

      if (res == "success") {
        setState(() {
          _isLoading = false;
          _isAddingItem = false;
        });
        showSnackBar(context, 'Added');
        _descriptionController.clear();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, res);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, e.toString());
    }
  }

  void _editItemDescription(String shoppingItemId, String currentDescription,
      double currentPrice) async {
    TextEditingController descriptionController =
        TextEditingController(text: currentDescription);
    TextEditingController priceController =
        TextEditingController(text: currentPrice.toString());

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Item',
            style: TextStyle(color: brownColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Enter the new description',
                ),
                maxLength: 30,
              ),
              SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter the new price',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: greyColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                final newDescription = descriptionController.text;
                final newPrice =
                    double.tryParse(priceController.text) ?? currentPrice;
                _updateItem(shoppingItemId, newDescription, newPrice);
                Navigator.of(context).pop();
              },
              child: Text(
                'Save',
                style: TextStyle(color: amberColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _updateItem(
      String shoppingItemId, String newDescription, double newPrice) async {
    try {
      await FirebaseFirestore.instance
          .collection('shoppingItems')
          .doc(shoppingItemId)
          .update({
        'description': newDescription,
        'price': newPrice,
      });
      showSnackBar(context, 'Item updated successfully');
    } catch (e) {
      showSnackBar(context, 'Failed to update item: $e');
    }
  }

  void _deleteItem(String shoppingItemId) async {
    try {
      await FirebaseFirestore.instance
          .collection('shoppingItems')
          .doc(shoppingItemId)
          .delete();
      showSnackBar(context, 'Item deleted successfully');
    } catch (e) {
      showSnackBar(context, 'Failed to delete item: $e');
    }
  }
}
