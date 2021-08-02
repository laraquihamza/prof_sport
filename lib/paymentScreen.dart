import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:prof_sport/models/Reservation.dart';
import 'package:prof_sport/models/ReservationService.dart';

class paymentScreen extends StatefulWidget {

  late Reservation reservation ;

  paymentScreen({required this.reservation});
  @override
  _paymentScreenState createState() => _paymentScreenState();
}

class _paymentScreenState extends State<paymentScreen> {

  String cardNumber="";
  String expiredate="";
  String cardholdername="";
   String cvvCode="";
   bool show=false;
   final GlobalKey<FormState> formKey= GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Wrap(
        children:
            [
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiredate,
                cardHolderName: cardholdername,
                cvvCode: cvvCode,
                showBackView: show, //true when you want to show cvv(back) view
              ),

              SizedBox(height: 20,),
              Expanded(
                child: SingleChildScrollView(
                child: Column(
                children: <Widget>[
                CreditCardForm(
                formKey: formKey,
                obscureCvv: true,
                obscureNumber: true,
                cardNumber: cardNumber,
                cvvCode: cvvCode,
                cardHolderName: cardholdername,
                expiryDate: expiredate,
                themeColor: Colors.blue,
                cardNumberDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                ),
                expiryDateDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Expired Date',
                  hintText: 'XX/XX',
                ),
                cvvCodeDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CVV',
                  hintText: 'XXX',
                ),
                cardHolderDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Card Holder',
                ),
                onCreditCardModelChange: onCreditCardModelChange,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  primary: const Color(0xff1b447b),
                ),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: const Text(
                    'Validate',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'halter',
                      fontSize: 14,
                      package: 'flutter_credit_card',
                    ),
                  ),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    ReservationService().pay_reservation(widget.reservation);
                    Navigator.pop(context);
                    print('valid!');
                  } else {
                    print('invalid!');
                  }
                },
              ),
             /* ElevatedButton(onPressed:
      ()async{
        ReservationService().pay_reservation(widget.reservation);
      }
, child: Text("Payer"))*/

            ]
      )
      )
              )
      ]
      ),
    );

  }
  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiredate = creditCardModel.expiryDate;
      cardholdername = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      show = creditCardModel.isCvvFocused;
    });
  }
}
