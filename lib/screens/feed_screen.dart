import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scraphive/screens/search_screen.dart';
import 'package:scraphive/widgets/scraphive_loader.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';
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
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
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
              EvaIcons.search,
              color: amberColor,
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SearchScreen(),
              ),
            ),
          ),
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
              return ScrapHiveLoader();
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
