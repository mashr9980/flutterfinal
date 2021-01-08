import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'TeacherAfterLogin.dart';

class AssignmnetTeacherSide extends StatefulWidget {
  final String tid;
  final String sid;
  final String tName;

  AssignmnetTeacherSide(
      {Key key, @required this.tid, @required this.sid, @required this.tName})
      : super(key: key);
  @override
  _AssignmnetTeacherSideState createState() =>
      _AssignmnetTeacherSideState(tid, sid, tName);
}

class _AssignmnetTeacherSideState extends State<AssignmnetTeacherSide> {
  final String tid;
  final String sid;
  final String tName;

  _AssignmnetTeacherSideState(this.tid, this.sid, this.tName);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        movetolastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => TeacherHome(uid: tid, name: tName)));
            },
          ),
          title: Text('SELECT A STUDENT'),
          backgroundColor: Color(0xFF00a79B),
        ),
        body: Container(),
      ),
    );
  }

  movetolastScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => TeacherHome(uid: tid, name: tName)));
  }
}
