import 'package:chatapp_firebase/pages/auth/register_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService authService = AuthService();
  String email = "";
  String password = "";
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (_isLoading)
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor))
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                  child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Text("Synapse",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          const Text(
                              "Connect with people and group chat on Synapse - start chatting",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400)),
                          Image.asset('assets/login3.jpg'),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email,
                                  color: Theme.of(context).primaryColor),
                            ),
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            validator: (value) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value!)
                                  ? null
                                  : "Please, Enter a valid email";
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                              labelText: "Password",
                              prefixIcon: Icon(Icons.lock,
                                  color: Theme.of(context).primaryColor),
                            ),
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            validator: (value) {
                              return (value!.length < 6)
                                  ? "Passwrod must be at least 6 characters"
                                  : null;
                            },
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  onPressed: () {
                                    login();
                                  },
                                  child: const Text("Sign In",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)))),
                          const SizedBox(height: 10),
                          Text.rich(
                            TextSpan(
                                text: "Don't have an account? ",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "Register here",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          nextScreenReplace(
                                              context, const RegisterPage());
                                        }),
                                ]),
                          )
                        ],
                      )),
                ),
              ));
  }

  login() async {
    setState(() {
      _isLoading = true;
    });

    await authService
        .loginInWithEmailandPassword(email, password)
        .then((value) async {
      if (value == true) {
        QuerySnapshot snapshot =
            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .gettingUserData(email);
        // saving the values to our shared preferences
        await HelperFunction.saveUserLoggedInStatus(true);
        await HelperFunction.saveUserEmailSF(email);
        await HelperFunction.saveUserNameSF(snapshot.docs[0]['fullName']);
        // ignore: use_build_context_synchronously
        nextScreenReplace(context, const HomePage());
      } else {
        showSnackBar(context, Colors.red, value);
        setState(() {
          _isLoading = false;
        });
      }
    });
  }
}
