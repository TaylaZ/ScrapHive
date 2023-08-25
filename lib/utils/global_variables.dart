import 'package:flutter/material.dart';
import 'package:scraphive/screens/add_post_screen.dart';
import 'package:scraphive/screens/feed_screen.dart';
import 'package:scraphive/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<Widget> homeScreenItems = [
  FeedScreen(),
  Text('2'),
  AddPostScreen(),
  Text('4'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  )
];
