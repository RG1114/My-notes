import 'package:flutter/material.dart';
import 'package:notes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context)
{
    return showGenericDialog(
      context: context,
       title: 'LOG OUT', 
       content: 'Are you sure that you want to log out ?',
        optionBuilder: ()=>{
          'Cancel':false,
          'Log out':true,
        },
        ).then(
          (value) => value??false,
        );
}