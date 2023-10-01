import 'package:flutter/material.dart';
import 'package:notes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context)
{
    return showGenericDialog(
      context: context,
       title: 'Delete', 
       content: 'Are you sure that you want to delete this item?',
        optionBuilder: ()=>{
          'Cancel':false,
          'Yes':true,
        },
        ).then(
          (value) => value??false,
        );
}