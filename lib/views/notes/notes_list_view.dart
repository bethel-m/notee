import 'package:flutter/material.dart';
import 'package:notee/services/cloud/cloud_note.dart';
import 'package:notee/services/crud/notes_service.dart';
import 'package:notee/utilities/diaglog/delete_dialog.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final BuildContext context;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;
  const NotesListView({
    super.key,
    required this.notes,
    required this.context,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return ListTile(
          onTap: () {
            onTap(note);
          },
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
          ),
        );
      },
    );
  }
}
