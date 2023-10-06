import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';

import 'package:notes/enums/menu_action.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/cloud/cloud_note.dart';
import 'package:notes/services/cloud/firebase_cloud_storage.dart';

import 'package:notes/utilities/dialogs/logout_dialog.dart';
import 'package:notes/views/notes/notes_list_view.dart';




class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}
 
class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;


  String get userId=>AuthService.firebase().currentUser!.id;

  @override
  void initState(){
    _notesService=FirebaseCloudStorage();
    
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
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);

          },
          icon: const Icon(Icons.add) 
          ),
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch(value){
              
              case MenuAction.logout:
                final shouldLogout=await showLogoutDialog(context);
                if (shouldLogout){
                  context.read<AuthBloc>().add(
                    const AuthEventLogOut()
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
      body:StreamBuilder(
                stream:_notesService.allNotes(ownerUserId: userId),
                builder:(context, snapshot){
                  switch (snapshot.connectionState){
                    
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                    if(snapshot.hasData)
                    {
                      final allNotes=snapshot.data as Iterable<CloudNote>;
                      return NotesListView(
                        notes: allNotes,
                       onDeleteNote: (note) async{
                        await _notesService.deleteNote(documentId:note.documentId );
                       },
                       onTap: (note) {
                         Navigator.of(context).pushNamed(
                          createOrUpdateNoteRoute,
                          arguments:note,
                         );
                       },
                       );
                      
                      

                    }else{
                      
                      
                      return const CircularProgressIndicator();
                    }
                    
                    

                    default:
                    
                    return const CircularProgressIndicator();
                  }

                }
              )
      
    );
  }
}






