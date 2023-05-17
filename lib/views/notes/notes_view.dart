import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

import 'package:notee/constants/routes.dart';
import 'package:notee/enums/menu_action.dart';
import 'package:notee/extensions/buildcontext/loc.dart';
import 'package:notee/services/auth/auth_service.dart';
import 'package:notee/services/auth/bloc/auth_bloc.dart';
import 'package:notee/services/auth/bloc/auth_event.dart';
import 'package:notee/services/cloud/cloud_note.dart';
import 'package:notee/services/cloud/firebase_cloud_storage.dart';

import 'package:notee/utilities/diaglog/logout_dialog.dart';
import 'package:notee/views/notes/notes_list_view.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String get userId => AuthService.firebase().currentUser!.id;
  late final FirebaseCloudStorage _noteService;
  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: StreamBuilder<int>(
              stream: _noteService.allNotes(ownerUserId: userId).getLength,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final noteCount = snapshot.data ?? 0;
                  final text = context.loc.notes_title(noteCount);
                  return Text(text);
                } else {
                  return const Text(
                    "",
                  );
                }
              }),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<MenuActions>(
              onSelected: (value) async {
                devtools.log(value.toString());
                switch (value) {
                  case MenuActions.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    devtools.log(shouldLogout.toString());
                    if (shouldLogout == true) {
                      if (context.mounted) {
                        context.read<AuthBloc>().add(const AuthEventLogOut());
                      }
                    }
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<MenuActions>(
                  value: MenuActions.logout,
                  child: Text(context.loc.logout_button),
                ),
              ],
            ),
          ],
        ),
        body: StreamBuilder(
          stream: _noteService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;

                  return NotesListView(
                    notes: allNotes,
                    context: context,
                    onDeleteNote: (note) async {
                      await _noteService.delete(documentId: note.documentId);
                    },
                    onTap: (CloudNote note) {
                      Navigator.of(context).pushNamed(
                        createOrUpdateNoteRoute,
                        arguments: note,
                      );
                    },
                  );
                }
                return const CircularProgressIndicator();
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
