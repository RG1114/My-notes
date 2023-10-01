import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';

import 'package:notes/enums/menu_action.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/crud/notes_service.dart';
import 'package:notes/utilities/dialogs/logout_dialog.dart';
import 'package:notes/views/notes/notes_list_view.dart';




class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;


  String get userEmail=>AuthService.firebase().currentUser!.email!;

  @override
  void initState(){
    _notesService=NotesService();
    
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:  const Text('Your Notes'),
        backgroundColor: const Color.fromARGB(255, 255, 162, 0),
        actions: [
          IconButton(
            onPressed:(){
              Navigator.of(context).pushNamed(newNoteRoute);

          },
          icon: const Icon(Icons.add) 
          ),
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
            
          },
          itemBuilder: (context){
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
      body:FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder:(context,snapshot){
          switch(snapshot.connectionState)
          {
            case ConnectionState.done:
              return StreamBuilder(
                stream:_notesService.allNotes,
                builder:(context, snapshot){
                  switch (snapshot.connectionState){
                    
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                    if(snapshot.hasData)
                    {
                      final allNotes=snapshot.data as List<DatabaseNote>;
                      return NotesListView(
                        notes: allNotes,
                       onDeleteNote: (note) async{
                        await _notesService.deleteNote(id: note.id);
                       },
                       );
                      
                      

                    }else{
                      
                      
                      return const CircularProgressIndicator();
                    }
                    
                    

                    default:
                    
                    return const CircularProgressIndicator();
                  }

                }
              );

            default:
            
            
            return const CircularProgressIndicator();
            
          }
          

        }
      ,)
      
    );
  }
}






