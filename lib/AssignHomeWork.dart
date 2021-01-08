import 'package:flutter/material.dart';
import 'auth_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'TeacherAfterLogin.dart';
import 'AssignmentTeacherSide.dart';

class AssignHomeWork extends StatefulWidget {
  final String tid;
  final String name;
  AssignHomeWork({Key key, @required this.tid, @required this.name})
      : super(key: key);
  @override
  _AssignHomeWorkState createState() => _AssignHomeWorkState(tid, name);
}

class _AssignHomeWorkState extends State<AssignHomeWork> {
  List userProfileList = [];
  final String tid;
  final String name;

  _AssignHomeWorkState(this.tid, this.name);

  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic result = await DatabaseManager().getallstudentList();

    if (result == null) {
      displayToastMessage('NOT RECORD FOUND', context);
    } else {
      setState(() {
        for (var i = 0; i < result.length; i++) {
          if (tid == result[i]['UID']) {
            userProfileList.add(result[i]);
          }
        }
      });
    }
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }

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
                  builder: (context) => TeacherHome(uid: tid, name: name)));
            },
          ),
          title: Text('SELECT A STUDENT'),
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
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => AssignmnetTeacherSide(
                              tid: userProfileList[index]['UID'],
                              sid: userProfileList[index]['Sid'],
                              tName: name)));
                    },
                  ),
                );
              }),
        ),
      ),
    );
  }

  movetolastScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => TeacherHome(uid: tid, name: name)));
  }
}
