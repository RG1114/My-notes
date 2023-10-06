import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
//import 'package:notes/firebase_options.dart';



class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:const Text('Email Verification')
      ),
      body: Column(children: [
          const Text("We have sent you an email verification, please open it to verify your email."),
          const Text("if you have not received the email , press the button below to send again  "),
          TextButton(
            onPressed: ()  {
              context.read<AuthBloc>().add(
                const AuthEventSendEmailVerification(),
              );
            },
            child: const Text('Send email verification'),
          ),
          TextButton(onPressed: ()async{
            context.read<AuthBloc>().add(
              const AuthEventLogOut(),
            );
            
          }, child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}