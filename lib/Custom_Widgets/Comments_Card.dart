import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/Providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/users.dart';

class CommentsCard extends StatefulWidget {
  final snap;
  const CommentsCard({super.key,required this.snap});

  @override
  State<CommentsCard> createState() => _CommentsCardState();
}

class _CommentsCardState extends State<CommentsCard> {
 
  @override
  Widget build(BuildContext context) {
    Timestamp t = widget.snap['datePublished'];
    DateTime d  = t.toDate();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      RichText(
                          text: TextSpan(
                          children: [
                          TextSpan(
                              text:  widget.snap['name'],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)
                          ),
                        ],
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(DateFormat.yMd().format(DateTime.parse(d.toString())) ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Colors.grey),),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                        text: TextSpan(
                            text:widget.snap['text'],
                            style: TextStyle(color:Colors.grey)
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: const Icon(Icons.favorite_border_outlined,size: 16,color: Colors.black,),
          )
        ],
      ),
    );
  }
}
