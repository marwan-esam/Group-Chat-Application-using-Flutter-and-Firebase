import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/profile_page.dart';
import 'package:chatapp_firebase/pages/search_page.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/group_tile.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../service/auth_service.dart';
import 'auth/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String userEmail = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  String getGroupId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getGroupName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunction.getUserEmailFromSF().then((value) {
      setState(() {
        userEmail = value!;
      });
    });

    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text("Groups",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 27)),
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SearchPage());
              },
              icon: const Icon(Icons.search))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(Icons.account_circle, size: 150, color: Colors.grey[700]),
            const SizedBox(height: 15),
            Text(userName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const Divider(height: 2),
            ListTile(
                onTap: () {},
                selectedColor: Theme.of(context).primaryColor,
                selected: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.group),
                title: const Text("Groups",
                    style: TextStyle(color: Colors.black))),
            ListTile(
                onTap: () {
                  nextScreenReplace(context,
                      ProfilePage(userName: userName, userEmail: userEmail));
                },
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
                          title: const Text("Logout"),
                          content:
                              const Text("Are you sure you want to logout?"),
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            popUpDialog(context);
          },
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          )),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: ((context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text("Create a group", textAlign: TextAlign.left),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor),
                      )
                    : TextField(
                        onChanged: (value) {
                          setState(() {
                            groupName = value;
                          });
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
              ]),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(userName,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.of(context).pop();
                        showSnackBar(context, Colors.green,
                            "Group created successfully.");
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text("Create"),
                ),
              ],
            );
          });
        }));
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        //make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null &&
              snapshot.data['groups'].length != 0) {
            return ListView.builder(
              itemCount: snapshot.data['groups'].length,
              itemBuilder: (context, index) {
                int reverseIndex = snapshot.data['groups'].length - index - 1;
                return GroupTile(
                    userName: snapshot.data['fullName'],
                    groupId: getGroupId(snapshot.data['groups'][reverseIndex]),
                    groupName:
                        getGroupName(snapshot.data['groups'][reverseIndex]));
              },
            );
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor));
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  popUpDialog(context);
                },
                child: Icon(
                  Icons.add_circle,
                  color: Colors.grey[700],
                  size: 75,
                ),
              ),
              GestureDetector(
                onTap: () {
                  nextScreen(context, const SearchPage());
                },
                child: Icon(
                  Icons.search,
                  color: Colors.grey[700],
                  size: 75,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "You've not joined any groups yet. Tap on the add icon to create a group or on the search icon to look for an already existing group",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
