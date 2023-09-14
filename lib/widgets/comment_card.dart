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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: brownColor,
                        ),
                      ),
                      Text(
                        '${snap.data()['text']}',
                        style: const TextStyle(
                          color: brownColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Text(
            DateFormat('dd/MM/yy').format(
              snap.data()['datePublished'].toDate(),
            ),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: greyColor,
            ),
          ),
        ],
      ),
    );
  }
}
