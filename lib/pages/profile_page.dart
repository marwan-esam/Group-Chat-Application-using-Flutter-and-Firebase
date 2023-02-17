import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String userEmail;
  ProfilePage({super.key, required this.userName, required this.userEmail});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: const Text("Profile",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 27))),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(Icons.account_circle, size: 150, color: Colors.grey[700]),
            const SizedBox(height: 15),
            Text(widget.userName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const Divider(height: 2),
            ListTile(
                onTap: () {
                  nextScreenReplace(context, const HomePage());
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.group),
                title: const Text("Groups",
                    style: TextStyle(color: Colors.black))),
            ListTile(
                onTap: () {},
                selected: true,
                selectedColor: Theme.of(context).primaryColor,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.person),
                title: const Text("Profile",
                    style: TextStyle(color: Colors.black))),
            ListTile(
                onTap: () async {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Logout"),
                          content: Text("Are you sure you want to logout?"),
                          actions: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.cancel,
                                    color: Colors.red)),
                            IconButton(
                                onPressed: () async {
                                  await authService.signOut();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (route) => false);
                                },
                                icon: const Icon(Icons.check_circle,
                                    color: Colors.green)),
                          ],
                        );
                      });
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.exit_to_app),
                title: const Text("Logout",
                    style: TextStyle(color: Colors.black))),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 130),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Full Name:",
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  widget.userName,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(
              height: 5,
              thickness: 1,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Email:",
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  widget.userEmail,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
