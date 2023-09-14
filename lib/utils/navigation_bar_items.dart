import 'package:flutter/material.dart';
import 'package:scraphive/screens/feed_screen.dart';
import 'package:scraphive/screens/scrapbook_screen.dart';
import 'package:scraphive/screens/liked_posts_screen.dart';
import 'package:scraphive/screens/materials_screen.dart';
import 'package:scraphive/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<Widget> homeScreenItems = [
  const FeedScreen(),
  LikedPostsScreen(),
  const ScrapbookScreen(),
  const MaterialScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  )
];
