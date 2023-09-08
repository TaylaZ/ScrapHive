import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scraphive/screens/creative_ideas.dart';
import 'package:scraphive/screens/search_screen.dart';
import 'package:scraphive/screens/start_scrapbooking.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ScrapHive_Logo.svg',
          height: 32,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              EvaIcons.menu,
              color: amberColor,
            ),
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ListTile(
              leading: Icon(
                EvaIcons.bulbOutline,
                color: amberColor,
                size: 32,
              ),
              title: Text(
                'Creative Ideas',
                style: TextStyle(fontSize: 18, color: amberColor),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ScrapbookingIdeasScreen(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(
                EvaIcons.bookOpenOutline,
                color: greenColor,
                size: 32,
              ),
              title: Text(
                'Start Scrapbooking',
                style: TextStyle(fontSize: 18, color: greenColor),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StartScrapbooking(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(
                EvaIcons.infoOutline,
                color: peachColor,
                size: 32,
              ),
              title: Text(
                'About ScrapHive',
                style: TextStyle(fontSize: 18, color: peachColor),
              ),
              onTap: () {},
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
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
