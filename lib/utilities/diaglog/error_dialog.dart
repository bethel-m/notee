import 'package:flutter/material.dart';
import 'package:notee/extensions/buildcontext/loc.dart';
import 'package:notee/utilities/diaglog/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String content) async {
  return await showGeneralGenericDialog(
    context: context,
    title: context.loc.generic_error_prompt,
    content: content,
    optionsBuilder: () {
      return {context.loc.ok: null};
    },
  );
}
