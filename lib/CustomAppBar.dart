import 'package:flutter/material.dart';
import 'package:prof_sport/main.dart';

import 'models/AuthImplementation.dart';
AppBar custom_appbar(String title, BuildContext context, bool logout){
  return AppBar(
    elevation: 0,
      automaticallyImplyLeading: false,
      foregroundColor: Colors.black,
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      backgroundColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: (){
              if(logout==true){
                Auth().signOut();
              }
              Navigator.pop(context);
              },
            child: Wrap(children: [
              Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              Text(
                "Retour",
                style: TextStyle(color: Colors.black),
              )
            ]),
          ),
          InkWell(
            child:Wrap(children: [
              Icon(
                Icons.logout,
                color: Colors.black,
              ),
              Text(
                "Déconnexion",
                style: TextStyle(color: Colors.black),
              )

            ]
            ),
            onTap: (){
              Auth().signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return MyApp();
              }));
            },

          ),
        ],
      )
  );

}