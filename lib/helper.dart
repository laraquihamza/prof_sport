import 'package:flutter/material.dart';
import 'package:prof_sport/CustomAppBar.dart';

import 'models/AuthImplementation.dart';

class Helper 
{

  Widget materialbutton(couleur, text, context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: couleur,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {},
        child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0)
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }


  // Verify Email Screen //

  Widget VerifyEmail(BuildContext context)
  {
    return Scaffold(
      appBar: custom_appbar(("Verify Email"), context, true, true),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Align(
            child: Text(
              "Verify Your Email",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
            alignment: Alignment.topLeft,
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            " Veuillez vérifier votre adresse e-mail\n à laquelle nous venons d'envoyer un email",
            style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
          ),
          SizedBox(height: 15.0,),

         // Button to reset Password email // 

         InkWell(
           child:materialbutton(Colors.blue[200], "Renvoyer Email de Verification", context),
           onTap: ()
           {
               // Send reset password to the user 
           }
         ), 
        ],
      ),
    );
  }


  // Reset Password // 



}

class Wrapper{
  late String str;
  Wrapper(String str){
    this.str=str;
  }
}