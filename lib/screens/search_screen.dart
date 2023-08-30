import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scraphive/screens/profile_screen.dart';
import 'package:scraphive/utils/colors.dart';
import 'package:scraphive/widgets/hexagon_button.dart';
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
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          isShowUsers
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
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                uid: (snapshot.data! as dynamic).docs[index]
                                    ['uid'],
                              ),
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(top: 50),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.amber.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['photoUrl'],
                                  ),
                                  radius: 32,
                                ),
                                title: Text(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['username'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
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
          // Positioned(
          //     top: 16,
          //     left: 16,
          //     child: !isShowUsers
          //         ? HexagonIconButton(
          //             icon: EvaIcons.arrowIosBack,
          //             onPressed: () {
          //               Navigator.pop(context);
          //             },
          //           )
          //         : HexagonIconButton(
          //             icon: EvaIcons.arrowIosBack,
          //             fillColor: amberColor,
          //             iconColor: primaryColor,
          //             onPressed: () {
          //               Navigator.pop(context);
          //             },
          //           )),
          Center(
            child: !isShowUsers
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(12),
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                          hintText: 'Search for a user',
                          hintStyle: TextStyle(
                            color: greyColor,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: greyColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onFieldSubmitted: (String _) {
                          setState(
                            () {
                              isShowUsers = true;
                            },
                          );
                        },
                      ),
                    ),
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}
