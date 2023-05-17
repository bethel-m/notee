import 'package:flutter/widgets.dart';
import 'package:notee/extensions/buildcontext/loc.dart';
import 'package:notee/utilities/diaglog/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) async {
  return showGeneralGenericDialog(
    context: context,
    title: context.loc.password_reset,
    content: context.loc.password_reset_dialog_prompt,
    optionsBuilder: () {
      return {context.loc.ok: null};
    },
  );
}
