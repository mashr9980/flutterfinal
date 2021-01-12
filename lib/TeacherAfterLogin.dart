import 'package:flutter/material.dart';
import 'StudentRegistration.dart';
import 'StudentsOfTeacher.dart';
import 'HomeScreen.dart';
import 'AssignHomeWork.dart';

class TeacherHome extends StatefulWidget {
  final String uid;
  final String name;
  TeacherHome({Key key, @required this.uid, @required this.name})
      : super(key: key);
  @override
  _TeacherHomeState createState() => _TeacherHomeState(uid, name);
}

class _TeacherHomeState extends State<TeacherHome> {
  final String uid;
  final String name;
  _TeacherHomeState(this.uid, this.name);
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
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 60,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              StufentSignUpScreen(tid: uid, tname: name)));
                    },
                    color: Color(0xFF00a79B),
                    child: Text(
                      'ADD STUDENTS',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 60,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => StudetsOfTeacher(
                              tid: uid, number: "2", name: name)));
                    },
                    color: Color(0xFF00a79B),
                    child: Text(
                      'VIEW STUDENTS',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 60,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AssignHomeWork(tid: uid, name: name)));
                    },
                    color: Color(0xFF00a79B),
                    child: Text(
                      'ASSIGN HOME WORK',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
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
                        Navigator.of(context).pushReplacement(
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
