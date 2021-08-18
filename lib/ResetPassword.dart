
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:prof_sport/helper.dart';
import 'package:toast/toast.dart';

import 'CustomAppBar.dart';
import 'models/AuthImplementation.dart';

class resetPassword extends StatefulWidget {
  @override
  _resetPasswordState createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
  Wrapper email=Wrapper("");
  @override
  Widget build(BuildContext context) {
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

            field("Email adress", email, false),

            SizedBox(height: 15.0,),

            // Button to reset Password email //

                materialbutton(Colors.blue[200], "Envoyer Instructions", context,()async
                {
                  await Auth().resetPassword(email.str);
                  Navigator.pop(context);

                }),
          ],
        ),
      );
  }

  Widget field(String namefield, Wrapper str, bool isPassword)
  {
    return Column(
      children: [
        SizedBox(height: 5,),

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
              hintText: namefield,
              hintStyle: TextStyle(fontSize: 15),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ),
        SizedBox(height: 10,),
      ],

    );
  }

Widget materialbutton(couleur, text, context,onPressed) {
  return Material(
    elevation: 5.0,
    borderRadius: BorderRadius.circular(30.0),
    color: couleur,
    child: MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      onPressed: onPressed,
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0)
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
    ),
  );
}

}


