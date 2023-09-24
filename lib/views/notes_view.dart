import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';

import 'package:notes/enums/menu_action.dart';




class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:  const Text('Main Ui'),
        backgroundColor: const Color.fromARGB(255, 255, 162, 0),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch(value){
              
              case MenuAction.logout:
                final shouldLogout=await showLogoutDialog(context);
                if (shouldLogout){
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute, 
                    (_) => false,
                    );
                }
                break;

                
            }
            
          },itemBuilder: (context){
            return const  [
              PopupMenuItem<MenuAction>(
              value: MenuAction.logout,
              child:Text('Log out'),
              ),
            ];
            
          },
        )
        ],
      ),
      
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context)
{
  return showDialog(
    context: context,
     builder: (context){
      return AlertDialog(
        title: const Text ('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions:[
          TextButton(onPressed:(){
            Navigator.of(context).pop(false);
          } ,
          child: const Text('Cancel')),
          TextButton(onPressed:(){
            Navigator.of(context).pop(true);
          } ,
          child: const Text('Logout')),
        ],
      );
     },
  ).then((value) => value ?? false);
}




