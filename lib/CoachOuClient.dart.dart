import 'package:flutter/material.dart';
import 'package:prof_sport/Signup_Client.dart';
import 'package:prof_sport/Signup_Coach.dart';

class CoachouClient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              children: [
                InkWell(
                  child: Wrap(
                    children: [Icon(Icons.arrow_back),
                      Text(
                        "Retour",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0),
                      )
    ]
    ),
      onTap: () {
        Navigator.pop(context);
      },
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 40.0,
            ),
            Center(
              child: Text(
                "Inscription",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Align(
                child: Text(
                  "Vous etes ?",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
            SizedBox(
              height: 65.0,
            ),
            Center(
                child: UserChoice(
              icon: Icons.person,
              text: "Coach",
              nextscreen: SignupCoach(
                title: "coach",
              ),
            )),
            SizedBox(
              height: 25.0,
            ),
            Center(
                child: UserChoice(
                    icon: Icons.fitness_center,
                    text: "Client",
                    nextscreen: SignupClient(
                      title: "client",
                    ))),
          ],
        ),
      ),
    );
  }
}

class UserChoice extends StatefulWidget {
  IconData? icon;
  String? text;
  bool isSelected = false;
  Widget nextscreen;

  UserChoice(
      {@required this.icon, @required this.text, required this.nextscreen});

  @override
  _UserChoiceState createState() => _UserChoiceState();
}

class _UserChoiceState extends State<UserChoice> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => widget.nextscreen));
        setState(() {
          widget.isSelected = !widget.isSelected;
        });
      },
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Row(
            children: [
              SizedBox(
                width: 75.0,
              ),
              Icon(
                widget.icon,
                color: widget.isSelected ? Colors.white : Colors.blue,
              ),
              SizedBox(
                width: 14.0,
              ),
              Text(
                widget.text.toString(),
                style: TextStyle(
                    color: widget.isSelected ? Colors.black : Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0),
              )
            ],
          ),
          width: MediaQuery.of(context).size.width * 0.64,
          height: 46.0,
          decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: widget.isSelected ? Colors.white : Colors.blue),
            borderRadius: BorderRadius.circular(8.0),
            color: widget.isSelected ? Colors.blue : Colors.white,
          ),
        ),
      ),
    );
  }
}
