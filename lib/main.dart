

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/firebase_options.dart';

import 'package:notes/views/login_view.dart';
import 'package:notes/views/register_view.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    ),);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:const Text('Home'),
        backgroundColor: Colors.red,
        
      ),
      body:FutureBuilder(
        future: Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform,
              ),

        builder:(context, snapshot) {
          switch(snapshot.connectionState)
          {
            
            case ConnectionState.done:
              
              
              final user=FirebaseAuth.instance.currentUser;
              final emailVerified = user?.emailVerified ?? false;
              if(emailVerified)
              {
                print("you are verified");
              }
              else{
                print('you need to verify your email at first');
              }
              return const Text('done');
           

            default:
            return Text("Loading...");
              
          }
            
        },
         
      ),
    );
  }
}






