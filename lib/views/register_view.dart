import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;

  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register",
        ),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: "enter your email",
                    ),
                  ),
                  TextField(
                      controller: _password,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      enableSuggestions: false,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "enter your password",
                      )),
                  TextButton(
                    onPressed: () async {
                      try {
                        String email = _email.text;
                        String password = _password.text;
                        final newUser = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        print(newUser);
                      } on FirebaseAuthException catch (e) {
                        switch (e.code) {
                          case ("email-already-in-use"):
                            print("this email is already in use");
                            break;
                          case ("invalid-email"):
                            print("this email is invalid");
                            break;
                          case ("operation-not-allowed"):
                            print("operation not allowed");
                            break;
                          case ("weak-password"):
                            print("weak password");
                            break;
                          default:
                            print("something went wrong");
                        }
                      } catch (e) {
                        print("something went wrong");
                      }
                    },
                    child: const Text("Register"),
                  ),
                ],
              );
              break;
            default:
              return Text("loading");
          }
        },
      ),
    );
  }
}
