import 'package:flutter/material.dart';
import 'package:notee/extensions/buildcontext/loc.dart';
import 'package:notee/services/auth/auth_service.dart';
import 'package:notee/services/cloud/cloud_note.dart';
import 'package:notee/services/cloud/firebase_cloud_storage.dart';
import 'package:notee/utilities/diaglog/cannot_share_empty_note_dialog.dart';
import 'package:notee/utilities/generics/get_arguments.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNotesView extends StatefulWidget {
  const CreateUpdateNotesView({super.key});

  @override
  State<CreateUpdateNotesView> createState() => _CreateUpdateNotesViewState();
}

class _CreateUpdateNotesViewState extends State<CreateUpdateNotesView> {
  late final TextEditingController _textEditingController;
  late final FirebaseCloudStorage _notesService;
  CloudNote? _note;

  void _textEditingControllerListener() {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textEditingController.text;

    _notesService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setUpTextEditingController() {
    _textEditingController.removeListener(_textEditingControllerListener);
    _textEditingController.addListener(_textEditingControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _textEditingController.text = widgetNote.text;
      return widgetNote;
    }

    final existinNote = _note;
    if (existinNote != null) {
      return existinNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final newNote =
        await _notesService.createNewNote(ownerUserId: currentUser.id);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (_textEditingController.text.isEmpty && note != null) {
      await _notesService.delete(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textEditingController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.note),
        actions: [
          IconButton(
              onPressed: () async {
                final text = _textEditingController.text;
                if (text.isEmpty || _note == null) {
                  await showCannotDeleteEmptyNoteDialog(context);
                } else {
                  Share.share(text);
                }
              },
              icon: const Icon(Icons.share))
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setUpTextEditingController();
              return TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    hintText: context.loc.start_typing_your_note),
              );

            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
