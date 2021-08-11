
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'models/AuthImplementation.dart';

class resetPassword extends StatefulWidget {
  @override
  _resetPasswordState createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
  late String email ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset Password"),centerTitle: true,),
      body: Column(
        children:
        [
          Text("adresse e-mail"),
          TextField(
            onChanged:(s){
              setState(() {
                email=s;
              });
            },
          ),
          ElevatedButton(onPressed: (){
            if(EmailValidator.validate(email)){
              Auth().resetPassword(email);
              Toast.show("Mail envoyé !", context,duration: Toast.LENGTH_LONG);
              Navigator.pop(context);
            }
            else
              {
                Toast.show("Veuillez renseigner une adresse email valide", context,duration: Toast.LENGTH_LONG);
              }
          }, child:Text("Reset Password"))

        ],
      ),
    );
  }
}
