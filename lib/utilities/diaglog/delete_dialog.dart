import 'package:flutter/material.dart';
import 'package:notee/extensions/buildcontext/loc.dart';
import 'package:notee/utilities/diaglog/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) async {
  return await showGeneralGenericDialog<bool>(
      context: context,
      title: context.loc.delete,
      content: context.loc.delete_note_prompt,
      optionsBuilder: () {
        return {
          context.loc.cancel: false,
          context.loc.yes: true,
        };
      }).then((value) => value ?? false);
}
