import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth_helper.dart';
import 'AdminAfterLogin.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewAllStudets extends StatefulWidget {
  @override
  _ViewAllStudetsState createState() => _ViewAllStudetsState();
}

class _ViewAllStudetsState extends State<ViewAllStudets> {
  List userProfileList = [];

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
          title: Text('RECORD OF ALL STUDENTS'),
          backgroundColor: Color(0xFF00a79B),
        ),
        body: Container(
          child: ListView.builder(
              itemCount: userProfileList.length,
              itemBuilder: (context, index) {
                if (userProfileList[index]['Type'] == 'Student') {
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
