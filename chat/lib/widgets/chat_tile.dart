//import 'package:chat/models/chat.dart';
//import 'dart:js_interop_unsafe';
import 'package:chat/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
//import 'package:flutter_slidable/flutter_slidable.dart';

class ChatTile extends StatelessWidget {
  final UserProfile userProfile;
  final Function onTap;
  //final Chat chat;

  const ChatTile({
    super.key,
    required this.userProfile,
    required this.onTap,
    //required Chat chat,
    //required this.chat,
  });

  void deleteChat(id) {
    FirebaseFirestore.instance.collection("chats").doc().delete();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            icon: Icons.delete,
            onPressed: (context) => {
              //deleteChat(snapshot.data.docs[Index].id) snapshot'a bak
            },
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          onTap();
        },
        dense: false,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            userProfile.pfpURL!,
          ),
        ),
        title: Text(
          userProfile.name!,
        ),
        subtitle: const Text("Tıklayıp mesaja ulaşabilirsin"),
      ),
    );
  }
}
