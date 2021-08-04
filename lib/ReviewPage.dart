import 'package:flutter/material.dart';
import 'package:prof_sport/CustomAppBar.dart';
import 'package:prof_sport/models/Reservation.dart';
import 'package:prof_sport/models/Review.dart';

import 'package:prof_sport/models/ReviewService.dart';

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();

  Reservation reservation ;

  ReviewPage(this.reservation);
}

class _ReviewPageState extends State<ReviewPage> {
  String comment="";
  int grade=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: custom_appbar("Review", context, false),
      body: Column(
        children:
        [
          DropdownButton<int>(
            value: grade,
            underline: Container(
              height: 2,
              color: Colors.blueAccent,
            ),
            onChanged: (int? newValue) {
              setState(() {
                grade = newValue!;
              });
            },
            items:[0,1,2,3,4,5]
                .map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(
                  value.toString(),
                  style: TextStyle(color: Colors.blueAccent),
                ),
              );
            }).toList(),
          ),
          Align(child: Text("commentaire"),),
          TextField(
            onChanged: (String? s){
              comment=s.toString();
            },
          ),

          ElevatedButton(
            child: Text('Submit'),
            onPressed: (){
              ReviewService().addReview(Review(idClient:widget.reservation.idclient,id:"",
                  idReservation: widget.reservation.id,idCoach: widget.reservation.idcoach,comment: comment,grade: grade));
            },
          )
        ],
      ),
    );
  }
}
