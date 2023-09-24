
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';



//import '../firebase_options.dart';
import 'dart:developer' as devtools;

import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/auth/auth_user.dart';
import 'package:notes/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}



class _LoginViewState extends State<LoginView> 
{
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState()
  {
    _email=TextEditingController();
    _password=TextEditingController();
    super.initState();
  }

  @override
  void dispose()
  {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.orange,
        
      ),
      body: Column(
            children: [
              TextField(
                controller:_email,
                enableSuggestions: false,
                autocorrect:false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: " Enter your EMAIL ID"
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect:false,
                decoration: const InputDecoration(
                  hintText: " Enter your password"
                )
              ),
              TextButton(
                onPressed:() async {
                
                
                final email=_email.text;
                final password=_password.text;
                try{
                    await AuthService.firebase().logIn(email: email, password: password);
                  
                final user=AuthService.firebase().currentUser;
                if(user?.isEmailVerified ??false){
                  Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, 
                (route) => false);

                }
                else{
                  Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute, 
                (route) => false);
                }
                }on  InvalidUserAuthException{
                  
                    await showErrorDialog(context,'Either the mail or the password is incorrect');
                  
                 }
                 on FirebaseAuthException catch (e){
                   await showErrorDialog(context,'Error: ${e.code}');

                 }
                 catch(e)
                {
                  await showErrorDialog(context,e.toString());
                }
                
                
              },
              child: const Text('Login') ,
              ),
              TextButton(
                onPressed: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute,
    
                   (route) => false,
                  );
                },
                child: const Text('Not registered yet? register here !'),
              )
            ],
          ),
    );
  }
}
