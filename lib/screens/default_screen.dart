import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scraphive/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:scraphive/utils/global_variables.dart';
import 'package:scraphive/widgets/hexagon_button.dart';
import '../models/user.dart' as usermodel;
import 'package:flutter/cupertino.dart';
import '../utils/colors.dart';

class DefaultScreen extends StatefulWidget {
  const DefaultScreen({Key? key}) : super(key: key);

  @override
  State<DefaultScreen> createState() => _DefaultScreenState();
}

class _DefaultScreenState extends State<DefaultScreen> {
  String username = "";
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    addData();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              (_page == 0) ? EvaIcons.home : EvaIcons.homeOutline,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              (_page == 1) ? EvaIcons.personAdd : EvaIcons.personAddOutline,
            ),
            label: 'Follow',
          ),
          BottomNavigationBarItem(
            icon: Transform.translate(
              offset: Offset(0, 5),
              child: HexagonIcon(
                icon: EvaIcons.plus,
                iconSize: 32,
                iconColor: yellowColor,
                fillColor: (_page == 2) ? amberColor : greenColor,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              (_page == 3) ? EvaIcons.archive : EvaIcons.archiveOutline,
            ),
            label: 'Materials',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              (_page == 4) ? EvaIcons.person : EvaIcons.personOutline,
            ),
            label: 'Profile',
          ),
        ],
        iconSize: 20,
        selectedItemColor: amberColor,
        unselectedItemColor: brownColor,
        backgroundColor: yellowColor,
        onTap: navigationTapped,
        currentIndex: _page,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedFontSize: 12,
        unselectedFontSize: 10,
      ),
    );
  }
}
