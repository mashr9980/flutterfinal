import 'package:flutter/material.dart';
import 'package:home_work_lutter_app/AssignmentStudentSide.dart';
import 'HomeScreen.dart';

class StudentHome extends StatefulWidget {
  final String uid;
  final String name;
  final String sid;
  StudentHome({Key key, @required this.sid, @required this.uid, @required this.name})
      : super(key: key);
  @override
  _StudentHomeState createState() => _StudentHomeState(uid, sid, name);
}

class _StudentHomeState extends State<StudentHome> {
  final String uid;
  final String name;
  final String sid;
  _StudentHomeState(this.uid,this.sid, this.name);
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
            BackButtonWidget(uid, sid, name),
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
  final String uid;
  final String name;
  final String sid;
  BackButtonWidget(this.uid,this.sid, this.name);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                    name,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ),
              )
            ],
          )),
        ),
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
                      builder: (context) => AssignmnetStudentSide(
                          tid: uid,
                          sid: sid,
                          sName: name,
                      )));
                },
                color: Color(0xFF00a79B),
                child: Text(
                  'See Assignments',
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
    );
  }
}
