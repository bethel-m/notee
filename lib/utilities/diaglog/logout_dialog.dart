import 'package:flutter/material.dart';
import 'package:notee/extensions/buildcontext/loc.dart';
import 'package:notee/utilities/diaglog/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) async {
  return await showGeneralGenericDialog<bool>(
      context: context,
      title: context.loc.logout_button,
      content: context.loc.logout_dialog_prompt,
      optionsBuilder: () {
        return {
          context.loc.cancel: false,
          context.loc.logout_button: true,
        };
      }).then((value) => value ?? false);
}
