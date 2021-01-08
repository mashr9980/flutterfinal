import 'package:flutter/material.dart';
import 'auth_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'ViewAllTeacher.dart';
import 'TeacherAfterLogin.dart';

class StudetsOfTeacher extends StatefulWidget {
  final String tid;
  final String number;
  final String name;
  StudetsOfTeacher(
      {Key key, @required this.tid, @required this.number, @required this.name})
      : super(key: key);
  @override
  _StudetsOfTeacherState createState() =>
      _StudetsOfTeacherState(tid, number, name);
}

class _StudetsOfTeacherState extends State<StudetsOfTeacher> {
  List userProfileList = [];
  final String tid;
  final String number;
  final String name;

  _StudetsOfTeacherState(this.tid, this.number, this.name);

  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic result = await DatabaseManager().getallstudentList();
    print(result);

    if (result == null) {
      displayToastMessage('NOT RECORD FOUND', context);
    } else {
      setState(() {
        for (var i = 0; i < result.length; i++) {
          if (tid == result[i]['UID']) {
            print(result[i]);
            print(result[i]['UID']);
            userProfileList.add(result[i]);
          }
        }

        print(userProfileList);
      });
    }
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        movetolastScreen(number);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (number == "1") {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ViewFaculty()));
              } else if (number == "2") {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => TeacherHome(uid: tid, name: name)));
              }
            },
          ),
          title: Text('RECORD OF YOUR STUDENTS'),
          backgroundColor: Color(0xFF00a79B),
        ),
        body: Container(
          child: ListView.builder(
              itemCount: userProfileList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(userProfileList[index]['name']),
                    subtitle: Text(userProfileList[index]['Type']),
                    leading: CircleAvatar(
                      child: Image(
                        image: AssetImage('images/abc.jpg'),
                      ),
                    ),
                    //trailing: Text(userProfileList[index]['Subject']),
                  ),
                );
              }),
        ),
      ),
    );
  }

  movetolastScreen(number) {
    if (number == "1") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ViewFaculty()));
    } else if (number == "2") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => TeacherHome(uid: tid, name: name)));
    }
  }
}
