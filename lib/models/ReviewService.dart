import 'package:cloud_firestore/cloud_firestore.dart';

import 'Coach.dart';
import 'Review.dart';

class ReviewService
{

  void addReview(Review review)
  {
    var doc=FirebaseFirestore.instance.collection("reviews").doc();
    doc.set({
      "id":doc.id,
      'idCoach':review.idCoach,
      'idClient':review.idClient,
      'idReservation':review.idReservation,
      'grade':review.grade,
      'comment':review.comment
    });
  }
  Future<double> get_average(Coach coach) async{
    double average=0;
    var docs=(await FirebaseFirestore.instance.collection("reviews").
    where("idCoach",isEqualTo: coach.uid).snapshots().first).docs;
    if (docs.length==0){
      return -1;
    }
    else{
      var c;
      for (c in docs){
        average+=c["grade"];
      }
    }


    return average/docs.length;
  }
}