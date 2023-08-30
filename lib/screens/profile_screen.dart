import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
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
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: primaryColor,
              titleSpacing: 0, // To remove default title spacing
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16), // Adjust as needed
                        child: SvgPicture.asset(
                          'assets/ScrapHive_Logo.svg',
                          height: 32,
                        ),
                      ),
                      SizedBox(width: 10), // Space between logo and username
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 16), // Adjust as needed
                    child: Text(
                      "${userData['username']}'s Profile",
                      style: TextStyle(
                        color: greenColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              centerTitle: false,
            ),
            body: Container(
              color: primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                userData['photoUrl'],
                              ),
                              radius: 40,
                            ),
                          ],
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildStatColumn(postLen, "posts"),
                                  buildStatColumn(followers, "followers"),
                                  buildStatColumn(following, "following"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FirebaseAuth.instance.currentUser!.uid ==
                                          widget.uid
                                      ? FollowButton(
                                          text: 'Sign Out',
                                          backgroundColor: greyColor,
                                          textColor: primaryColor,
                                          function: () async {
                                            await AuthMethods().signOut();
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen(),
                                              ),
                                            );
                                          },
                                        )
                                      : isFollowing
                                          ? FollowButton(
                                              text: 'Unfollow',
                                              backgroundColor: Colors.white,
                                              textColor: Colors.black,
                                              function: () async {
                                                await FireStoreMethods()
                                                    .followUser(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  userData['uid'],
                                                );

                                                setState(() {
                                                  isFollowing = false;
                                                  followers--;
                                                });
                                              },
                                            )
                                          : FollowButton(
                                              text: 'Follow',
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.white,
                                              function: () async {
                                                await FireStoreMethods()
                                                    .followUser(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  userData['uid'],
                                                );

                                                setState(() {
                                                  isFollowing = true;
                                                  followers++;
                                                });
                                              },
                                            )
                                ],
                              ),
                            ],
                          ),
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

                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: InkWell(
                                      onTap: () {
                                        
                                      },
                                      child: Image(
                                        image: NetworkImage(snap['postUrl']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Row(
                                      children: [
                                        Icon(EvaIcons.heart, color: amberColor),
                                        SizedBox(width: 5),
                                        Text(
                                          snap['likes'].length == 1
                                              ? '${snap['likes'].length} Like'
                                              : '${snap['likes'].length} Likes',
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: amberColor,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: greyColor,
            ),
          ),
        ),
      ],
    );
  }
}
