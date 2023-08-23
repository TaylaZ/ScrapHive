import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scraphive/utils/colors.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              snap.data()['profilePic'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snap.data()['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: brownColor,
                        ),
                      ),
                      Text(
                        '${snap.data()['text']}',
                        style: TextStyle(
                          color: brownColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Text(
              DateFormat('dd/MM/yy').format(
                snap.data()['datePublished'].toDate(),
              ),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: greyColor,
              ),
            ),
          ),
          //  Container(
          //   padding: const EdgeInsets.all(8),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       const Icon(
          //         EvaIcons.heartOutline,
          //         color: amberColor,
          //         size: 18,
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(
          //           top: 8,
          //         ),
          //         child: Text(
          //           DateFormat('dd/M').format(
          //             snap.data()['datePublished'].toDate(),
          //           ),
          //           style: const TextStyle(
          //             fontSize: 12,
          //             fontWeight: FontWeight.w400,
          //             color: greyColor,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
