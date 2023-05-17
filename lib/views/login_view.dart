import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notee/extensions/buildcontext/loc.dart';
import 'package:notee/services/auth/auth_exceptions.dart';
import 'package:notee/services/auth/bloc/auth_bloc.dart';
import 'package:notee/services/auth/bloc/auth_event.dart';
import 'package:notee/services/auth/bloc/auth_state.dart';
import 'package:notee/utilities/diaglog/error_dialog.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
                context, context.loc.login_error_cannot_find_user);
          }
          if (state.exception is WrongPasswordAuthException ||
              state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
                context, context.loc.login_error_wrong_credentials);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, context.loc.login_error_auth_error);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(context.loc.login)),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(context.loc.login_view_prompt),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: context.loc.email_text_field_placeholder,
                ),
              ),
              TextField(
                  controller: _password,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  enableSuggestions: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: context.loc.password_text_field_placeholder,
                  )),
              TextButton(
                onPressed: () {
                  String email = _email.text;
                  String password = _password.text;
                  context.read<AuthBloc>().add(
                        AuthEventLogIn(
                          email: email,
                          password: password,
                        ),
                      );
                },
                child: Text(context.loc.login),
              ),
              TextButton(
                  onPressed: () {
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventForgotPassword());
                  },
                  child: Text(context.loc.forgot_password)),
              TextButton(
                  onPressed: () {
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventShouldRegister());
                  },
                  child: Text(context.loc.login_view_not_registered_yet))
            ],
          ),
        ),
      ),
    );
  }
}
