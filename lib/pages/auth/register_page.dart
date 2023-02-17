import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthService authService = AuthService();
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String fullName = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
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
                              "Stay connected with groups on Synapse - join now",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400)),
                          Image.asset('assets/register2.jpg'),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              labelText: "Full Name",
                              prefixIcon: Icon(Icons.person,
                                  color: Theme.of(context).primaryColor),
                            ),
                            onChanged: (value) {
                              setState(() {
                                fullName = value;
                              });
                            },
                            validator: (value) {
                              return (value!.isNotEmpty)
                                  ? null
                                  : "Name cannot be empty";
                            },
                          ),
                          const SizedBox(height: 15),
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
                                    register();
                                  },
                                  child: const Text("Register",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)))),
                          const SizedBox(height: 10),
                          Text.rich(
                            TextSpan(
                                text: "Already have an account? ",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "Login now",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          nextScreenReplace(
                                              context, const LoginPage());
                                        }),
                                ]),
                          )
                        ],
                      )),
                ),
              ));
  }

  register() async {
    setState(() {
      _isLoading = true;
    });

    await authService
        .registerUserWithEmailandPassword(fullName, email, password)
        .then((value) async {
      if (value == true) {
        //saving the shared preferences state
        await HelperFunction.saveUserLoggedInStatus(true);
        await HelperFunction.saveUserEmailSF(email);
        await HelperFunction.saveUserNameSF(fullName);
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
