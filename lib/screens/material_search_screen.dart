import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scraphive/screens/profile_screen.dart';
import 'package:scraphive/utils/colors.dart';
import 'package:scraphive/widgets/hexagon_avatar.dart';
import 'package:scraphive/widgets/hexagon_icon.dart';
import 'package:scraphive/widgets/scraphive_loader.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MaterialSearchScreen extends StatefulWidget {
  const MaterialSearchScreen({Key? key}) : super(key: key);

  @override
  State<MaterialSearchScreen> createState() => _MaterialSearchScreenState();
}

class _MaterialSearchScreenState extends State<MaterialSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                EvaIcons.arrowIosBack,
                color: amberColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          isShowUsers
              ? FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('materials')
                      .where(
                        'description',
                        isEqualTo: searchController.text,
                      )
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return ScrapHiveLoader();
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(top: 50),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: amberColor.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            child: ListTile(
                              leading: HexagonAvatar(
                                image: NetworkImage(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['materialsUrl'],
                                ),
                                radius: 28,
                              ),
                              title: Text(
                                '${(snapshot.data! as dynamic).docs[index]['description']} ${(snapshot.data! as dynamic).docs[index]['percentage']}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: brownColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              : Center(
                  child: !isShowUsers
                      ? Transform.translate(
                          offset: Offset(0, -30),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Material(
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/ScrapHive_Logo.svg',
                                    height: 62,
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  TextFormField(
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      hintText: 'Search for your material',
                                      hintStyle: TextStyle(
                                        color: greyColor,
                                      ),
                                      prefixIcon: Icon(
                                        EvaIcons.search,
                                        color: greyColor,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: whiteColor,
                                    ),
                                    onFieldSubmitted: (String _) {
                                      setState(
                                        () {
                                          isShowUsers = true;
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ),
        ],
      ),
    );
  }
}
