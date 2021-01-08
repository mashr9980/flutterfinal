import 'package:flutter/material.dart';
import 'HomeScreen.dart';

class StudentHome extends StatefulWidget {
  final String uid;
  final String name;
  StudentHome({Key key, @required this.uid, @required this.name})
      : super(key: key);
  @override
  _StudentHomeState createState() => _StudentHomeState(uid, name);
}

class _StudentHomeState extends State<StudentHome> {
  final String uid;
  final String name;
  _StudentHomeState(this.uid, this.name);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        movetolastScreen();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            BackButtonWidget(Name: name),
            SizedBox(height: 50)
          ],
        ),
      ),
    );
  }

  movetolastScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }
}

class BackButtonWidget extends StatelessWidget {
  String Name;
  BackButtonWidget({Key key, @required this.Name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('images/app.png'))),
      child: Positioned(
          child: Stack(
        children: <Widget>[
          Positioned(
              top: 20,
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      }),
                  Text(
                    'Back',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              )),
          Positioned(
            bottom: 20,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                Name,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
          )
        ],
      )),
    );
  }
}
