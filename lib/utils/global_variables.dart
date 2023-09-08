import 'package:flutter/material.dart';

import 'package:scraphive/screens/add_post_screen.dart';
import 'package:scraphive/screens/feed_screen.dart';
import 'package:scraphive/screens/materials_screen.dart';
import 'package:scraphive/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scraphive/screens/search_screen.dart';

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  MaterialScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  )
];
