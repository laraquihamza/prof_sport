import 'package:flutter/material.dart';
import 'package:prof_sport/CustomAppBar.dart';

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

  Widget field(
      String namefield, String hintfield, Wrapper str, bool isPassword) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(namefield),
        ),
        TextField(
          obscureText: isPassword,
          keyboardType: TextInputType.text,
          onChanged: (s) {
            setState(() {
              str.str = s;
            });
          },
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: hintfield,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ),
      ],
    );
  }

  // Verify Email Screen //

  Widget VerifyEmail() 
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
          materialbutton(Colors.blue[200], "Envoyer Instructions", context),
        ],
      ),
    );
  }


  // Reset Password // 

  Widget ResetPassword() 
  {
    return Scaffold(
      appBar: custom_appbar(("Reset Password"), context, true, true),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Align(
            child: Text(
              "Reset Password",
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
            "Entrez un email associé avec votre compte\n et nous vous envoyons un email avec les instructions pour avoir un nouveau mot de passe",
            style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
          ),
          SizedBox(height: 15.0,),

          // 
          
          field("Email adress", "votre email adresse ", Wrapper str, false),

          SizedBox(height: 15.0,),
         
         // Button to reset Password email // 

         InkWell(
           child:materialbutton(Colors.blue[200], "Envoyer Instructions", context),
           onTap: ()
           {
               // Send reset password to the user 
           }
         ), 
          materialbutton(Colors.blue[200], "Envoyer Instructions", context),
        ],
      ),
    );
  }



}
