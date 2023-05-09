import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
          "Login",
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
                            .signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        print(newUser);
                      } on FirebaseAuthException catch (e) {
                        switch (e.code) {
                          case ("wrong-password"):
                            print("wrong-password");
                            break;
                          case ("invalid-email"):
                            print("invalid-email");
                            break;
                          case ("user-not-found"):
                            print("user is not found");
                            break;
                          case ("user-disabled"):
                            print("user is disabled");
                            break;
                          default:
                            print("something went wrong");
                        }
                      }
                    },
                    child: const Text("Login"),
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
