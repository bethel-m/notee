import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notee/constants/routes.dart';
import 'package:notee/helpers/loading/loading_screen.dart';
import 'package:notee/services/auth/bloc/auth_bloc.dart';
import 'package:notee/services/auth/bloc/auth_event.dart';
import 'package:notee/services/auth/bloc/auth_state.dart';
import 'package:notee/services/auth/firebase_auth_provider.dart';
import 'package:notee/views/email_verification.dart';
import 'package:notee/views/forgot_password_view.dart';
import 'package:notee/views/login_view.dart';
import 'package:notee/views/notes/create_update_notes_view.dart';
import 'package:notee/views/register_view.dart';
import 'package:notee/views/notes/notes_view.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNotesView(),
      },
      home: BlocProvider(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: "Please wait a momment");
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateNeedsVerification) {
          return const EmailVerificationView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
