import 'package:flutter/material.dart';
import 'package:notes/utilities/dialogs/generic_dialog.dart';

Future <void> showPasswordRestSentDialog(BuildContext context){
  return showGenericDialog(context: context
  , title: 'Password Reset',
   content: "Please check your email for password reset link"
   , optionBuilder: ()=>{
    'ok':null,
   });
}