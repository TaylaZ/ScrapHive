import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scraphive/screens/add_post_screen.dart';
import 'package:scraphive/screens/search_screen.dart';
import 'package:scraphive/widgets/hexagon_icon.dart';
import 'package:scraphive/widgets/scraphive_loader.dart';
import '../utils/colors.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection('posts')
        .orderBy(
          'datePublished',
          descending: true,
        )
        .snapshots();
  }

  Future<void> _refreshData() async {
    setState(() {
      _stream = FirebaseFirestore.instance
          .collection('posts')
          .orderBy(
            'datePublished',
            descending: true,
          )
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ScrapHive_Logo.svg',
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
            icon: const Icon(
              EvaIcons.search,
              color: amberColor,
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        backgroundColor: amberColor,
        color: yellowColor,
        displacement: 0,
        child: StreamBuilder(
          stream: _stream,
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ScrapHiveLoader();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddPostScreen(),
            ),
          );
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
    );
  }
}
