import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:scraphive/models/user.dart' as model;
import 'package:scraphive/providers/user_provider.dart';
import 'package:scraphive/utils/colors.dart';

import 'package:scraphive/widgets/post_card.dart';
import 'package:scraphive/widgets/scraphive_loader.dart';

class LikedPostsScreen extends StatefulWidget {
  @override
  _LikedPostsScreenState createState() => _LikedPostsScreenState();
}

class _LikedPostsScreenState extends State<LikedPostsScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    super.initState();
    final model.User user =
        Provider.of<UserProvider>(context, listen: false).getUser;

    // Fetch posts that the user has liked
    _stream = FirebaseFirestore.instance
        .collection('posts')
        .where('likes', arrayContains: user.uid)
        .orderBy(
          'datePublished',
          descending: true,
        )
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ScrapHive_Logo.svg',
          height: 32,
        ),
      ),
      body: Container(
        color: primaryColor,
        child: StreamBuilder(
          stream: _stream,
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ScrapHiveLoader();
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                  child: Text(
                'No Liked posts yet~',
                style: TextStyle(color: greyColor),
              ));
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) => PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            );
          },
        ),
      ),
    );
  }
}
