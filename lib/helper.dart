import 'package:flutter/material.dart';

class Helper 
{

  Widget materialbutton(couleur, text, context) 
  {
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
  


   Widget field(String name_field, Wrapper str, bool isPassword) 
   {
    return TextField(
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
          hintText: name_field,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }
 
  

}
