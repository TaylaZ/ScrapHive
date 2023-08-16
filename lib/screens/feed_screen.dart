import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: primaryColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ScrapHive_Logo.svg',
          height: 32,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              EvaIcons.bell,
              color: amberColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: const PostCard(),
    );
  }
}
