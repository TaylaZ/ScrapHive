import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scraphive/utils/colors.dart';
import 'package:scraphive/widgets/scraphive_loader.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                EvaIcons.arrowIosBack,
                color: amberColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Search for a user',
            labelStyle: TextStyle(
              color: greyColor,
            ),
          ),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUsers = true;
            });
          },
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return ScrapHiveLoader();
                }

                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {},
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]['photoUrl'],
                          ),
                          radius: 16,
                        ),
                        title: Text(
                          (snapshot.data! as dynamic).docs[index]['username'],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy(
                    'datePublished',
                    descending: true,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return ScrapHiveLoader();
                }

                return MasonryGridView.count(
                  crossAxisCount: 2,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      (snapshot.data! as dynamic).docs[index]['postUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  padding: EdgeInsets.all(8),
                );
              },
            ),
    );
  }
}
