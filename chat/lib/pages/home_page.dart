// ignore_for_file: unused_local_variable

import 'package:chat/models/user_profile.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/services/alert_service.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/database_service.dart';
import 'package:chat/services/navigation_service.dart';
import 'package:chat/widgets/chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GetIt _getIt = GetIt.instance;

  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseService>();
  }

  loadImg() async {
    final user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('users')
        .doc('pfpURL')
        .get();

    print(variable);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.messages,
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: null,
                // user?['pfpURL'];
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(AppLocalizations.of(context)!.homepage),
              onTap: () {
                _navigationService.pushReplacementNamed("/home");
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.settings),
              onTap: () {
                _navigationService.pushReplacementNamed("/settings");
              },
            ),
            ListTile(
                leading: const Icon(Icons.logout),
                title: Text(AppLocalizations.of(context)!.logout),
                onTap: () async {
                  bool result = await _authService.logout();
                  if (result) {
                    _alertService.showToast(
                        text: "Çıkış yapıldı", icon: Icons.check);
                    _navigationService.pushReplacementNamed("/login");
                  }
                }),
          ],
        ),
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
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  UserProfile user = users[index].data();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ChatTile(
                      userProfile: user,
                      onTap: () async {
                        final chatExists =
                            await _databaseService.checkChatExists(
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
                });
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}


//TODO:
// Drawer eklenmeli
// Drawer da home sayfası, Settings, çıkış 
// Tema seçeneği eklenmeli( Settings sayfasında) //Localization sana bırakıyorum
// Mesajlar silinebilmeli
// Mesajlar listesinde isim altında son mesaj görüntülensin
// Floating Button eklenmeli basınca Kime mesajı şeklinde gösterilmeli Kişler listelenmeli 