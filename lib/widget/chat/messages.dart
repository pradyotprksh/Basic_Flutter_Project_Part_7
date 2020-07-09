import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/widget/chat/message_bubble.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (futureContext, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy(
                'createdAt',
                descending: true,
              )
              .snapshots(),
          builder: (streamContext, messageSnapshot) {
            if (messageSnapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            var snapshot = messageSnapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.only(top: 10),
              reverse: true,
              itemCount: snapshot.length,
              itemBuilder: (listContext, position) {
                return MessageBubble(
                    snapshot[position]['text'],
                    snapshot[position]['userName'],
                    snapshot[position]['userImage'],
                    snapshot[position]['userId'] == futureSnapshot.data.uid,
                    ValueKey(
                      snapshot[position].documentID,
                    ));
              },
            );
          },
        );
      },
    );
  }
}
