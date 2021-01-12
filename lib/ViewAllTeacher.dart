import 'package:flutter/material.dart';
import 'auth_helper.dart';
import 'AdminAfterLogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'StudentsOfTeacher.dart';

class ViewFaculty extends StatefulWidget {
  @override
  _ViewFacultyState createState() => _ViewFacultyState();
}

class _ViewFacultyState extends State<ViewFaculty> {
  List userProfileList = [];

  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic result = await DatabaseManager().getUserList();

    if (result == null) {
      displayToastMessage('NOT RECORD FOUND', context);
    } else {
      setState(() {
        userProfileList = result;
        //print(userProfileList);
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
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AdminHome()));
            },
          ),
          title: Text('RECORD OF ALL FACULTY'),
          backgroundColor: Color(0xFF00a79B),
        ),
        body: Container(
          child: ListView.builder(
              itemCount: userProfileList.length,
              itemBuilder: (context, index) {
                if (userProfileList[index]['Type'] == 'Teacher') {
                  return Card(
                    child: ListTile(
                      title: Text(userProfileList[index]['name']),
                      subtitle: Text(userProfileList[index]['Type']),
                      leading: CircleAvatar(
                        child: Image(
                          image: AssetImage('images/abc.jpg'),
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => StudetsOfTeacher(
                                tid: userProfileList[index]['UID'],
                                number: "1",
                                name: null)));
                      },
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }

  movetolastScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AdminHome()));
  }
}
