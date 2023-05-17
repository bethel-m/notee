import 'package:flutter/material.dart';
import 'package:notee/extensions/buildcontext/loc.dart';
import 'package:notee/utilities/diaglog/generic_dialog.dart';

Future<void> showCannotDeleteEmptyNoteDialog(BuildContext context) async {
  return await showGeneralGenericDialog<void>(
    context: context,
    title: context.loc.sharing,
    content: context.loc.cannot_share_empty_note_prompt,
    optionsBuilder: () {
      return {context.loc.ok: null};
    },
  );
}
