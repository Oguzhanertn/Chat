//import 'package:chat/models/chat.dart';
import 'package:chat/models/user_profile.dart';
import 'package:chat/pages/chat_page.dart';
//import 'package:chat/services/alert_service.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/database_service.dart';
import 'package:chat/services/navigation_service.dart';
import 'package:chat/widgets/chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final GetIt _getIt = GetIt.instance;
  final user = FirebaseAuth.instance.currentUser;
  final chat = FirebaseFirestore.instance.collection('chats');

  late AuthService _authService;
  late NavigationService _navigationService;
  //late AlertService _alertService;
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    //_alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseService>();
  }

  loadImg() async {
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('users')
        .doc('pfpURL')
        .get();

    print("foto: $variable");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.contents,
        ),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              _navigationService.pushReplacementNamed("/home");
            }),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: _chatsList(),
      ),
    );
  }

  // Widget _messagesList() => StreamBuilder(
  //     stream: _databaseService.getMessages(),
  //     builder: (context, snapshot) {
  //       return _chatsList();
  //     });

  Widget _chatsList() {
    return StreamBuilder(
      stream: _databaseService.getUserProfiles(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Sohbetler yüklenemedi"),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          final users = snapshot.data!.docs;
          //final chats = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              UserProfile user = users[index].data();
              //Chat chat = chats[index].data() as Chat;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ChatTile(
                  //chat: chat,
                  userProfile: user,
                  onTap: () async {
                    final chatExists = await _databaseService.checkChatExists(
                      _authService.user!.uid,
                      user.uid!,
                    );
                    if (!chatExists) {
                      await _databaseService.createNewChat(
                        _authService.user!.uid,
                        user.uid!,
                      );
                    }
                    _navigationService.push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ChatPage(
                            chatUser: user,
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
