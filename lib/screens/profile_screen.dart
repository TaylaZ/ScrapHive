import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:scraphive/screens/add_post_screen.dart';
import 'package:scraphive/screens/creative_ideas.dart';
import 'package:scraphive/screens/image_view_screen.dart';
import 'package:scraphive/screens/search_screen.dart';
import 'package:scraphive/widgets/hexagon_avatar.dart';
import 'package:scraphive/widgets/hexagon_button.dart';
import 'package:scraphive/widgets/scraphive_loader.dart';
import '../resources/auth_methods.dart';
import '../resources/firestore_methods.dart';
import '../screens/login_screen.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? ScrapHiveLoader()
        : Scaffold(
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
                crossAxisAlignment: CrossAxisAlignment.end,
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
                      EvaIcons.personAddOutline,
                      color: greenColor,
                      size: 32,
                    ),
                    title: Text(
                      'Find Your Friend',
                      style: TextStyle(fontSize: 18, color: greenColor),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SearchScreen(),
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
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: TextButton(
                      onPressed: () async {
                        await AuthMethods().signOut();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                          color: greyColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Container(
              color: primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    HexagonAvatar(
                      image: NetworkImage(
                        userData['photoUrl'],
                      ),
                      radius: 40,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${userData['username']}",
                          style: TextStyle(
                            color: amberColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        FirebaseAuth.instance.currentUser!.uid == widget.uid
                            ? SizedBox(
                                height: 0,
                                width: 0,
                              )
                            : isFollowing
                                ? IconButton(
                                    onPressed: () async {
                                      await FireStoreMethods().followUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        userData['uid'],
                                      );

                                      setState(() {
                                        isFollowing = false;
                                        followers--;
                                      });
                                    },
                                    icon: Icon(
                                      EvaIcons.personRemove,
                                      color: greyColor,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () async {
                                      await FireStoreMethods().followUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        userData['uid'],
                                      );

                                      setState(() {
                                        isFollowing = true;
                                        followers++;
                                      });
                                    },
                                    icon: Icon(
                                      EvaIcons.personAdd,
                                      color: greenColor,
                                    ),
                                  )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              postLen.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: amberColor,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              child: Text(
                                "no. posts",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: greyColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              followers.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: greenColor,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              child: Text(
                                "followers",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: greyColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              following.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: peachColor,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              child: Text(
                                "following",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: greyColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
          
                    const Divider(),
                    Expanded(
                      child: FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ScrapHiveLoader();
                          }

                          if ((snapshot.data! as dynamic).docs.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    "You have not posted anything yet",
                                    style: TextStyle(
                                      color: greyColor,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => AddPostScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Post Something Now",
                                      style: TextStyle(
                                        color: amberColor,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }

                          return GridView.builder(
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  (snapshot.data! as dynamic).docs[index];

                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ImageViewScreen(
                                        imageUrl: snap['postUrl'],
                                      ),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    snap['postUrl'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }


}
