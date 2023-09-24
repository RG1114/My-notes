//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import '../firebase_options.dart';
import 'dart:developer' as devtools;

import 'package:notes/constants/routes.dart';
import 'package:notes/utilities/show_error_dialog.dart';



class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text("Register"),
        backgroundColor: Colors.red,
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
                final userCredential =
                  await  FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                devtools.log(userCredential.toString());
                }on FirebaseAuthException catch(e)
                {
                  
                  showErrorDialog(context,'Error: ${e.code}');
                  
                }catch(e)
                {
                  showErrorDialog(context, e.toString());
                }
                
              },
              child: const Text('Register') ,
              ),
            TextButton(onPressed:(){
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false
              );
              },

              child: const Text ('Already have an account? Login here '),
             )

            ],
          ),
    );
  }
}


