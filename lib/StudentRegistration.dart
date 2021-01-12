import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_work_lutter_app/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'TeacherAfterLogin.dart';

class StufentSignUpScreen extends StatefulWidget {
  final String tid;
  final String tname;

  StufentSignUpScreen({Key key, @required this.tid, @required this.tname})
      : super(key: key);
  @override
  _StufentSignUpScreenState createState() =>
      _StufentSignUpScreenState(tid, tname);
}

class _StufentSignUpScreenState extends State<StufentSignUpScreen> {
  final String tid;
  final String tname;
  _StufentSignUpScreenState(this.tid, this.tname);
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  String Desi = 'Student';

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
            BackButtonWidget(),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.person), onPressed: null),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(right: 20, left: 10),
                    child: TextField(
                      controller: nameTextEditingController,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                  ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.lock), onPressed: null),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(right: 20, left: 10),
                          child: TextField(
                            controller: passwordTextEditingController,
                            decoration: InputDecoration(hintText: 'Password'),
                          )))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.mail), onPressed: null),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(right: 20, left: 10),
                          child: TextField(
                            controller: emailTextEditingController,
                            decoration: InputDecoration(hintText: 'Email'),
                          )))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.work)),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(right: 20, left: 10),
                    child: Text('$Desi'),
                  ))
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 60,
                  child: RaisedButton(
                    onPressed: () {
                      if (nameTextEditingController.text.length < 4) {
                        displayToastMessage(
                            'Name must be atleast 3 Characters', context);
                      } else if (!emailTextEditingController.text
                          .contains("@")) {
                        displayToastMessage(
                            'Email Address is not Valid', context);
                      } else if (passwordTextEditingController.text.length <
                          7) {
                        displayToastMessage(
                            'Password must be atleast 6 Characters', context);
                      } else {
                        regesterNewUser(context);
                      }
                      //Navigator.pushNamed(context, 'Home');
                    },
                    color: Color(0xFF00a79B),
                    child: Text(
                      'Register',
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

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void regesterNewUser(BuildContext context) async {
    //DATA STORE ON FORESTORE
    await Firebase.initializeApp();
    UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailTextEditingController.text,
            password: passwordTextEditingController.text);
    User user = result.user;
    await user.updateProfile(displayName: nameTextEditingController.text);

    print(user);
    if (user != null) {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      DocumentReference ref = _firestore
          .collection('users')
          .doc(tid)
          .firestore
          .collection('student')
          .doc(user.uid);
      ref.set({
        'UID': tid.trim(),
        'Sid': user.uid,
        'name': nameTextEditingController.text.trim(),
        'email': emailTextEditingController.text.trim(),
        "Type": Desi.trim(),
      });
    }

    //DATA STORE ON  FIREBASE
    if (user != null) {
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "type": Desi.trim(),
      };
      userResf.child(user.uid).set(userDataMap);
      displayToastMessage(
          "Congradulations Your Account has been Created", context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => TeacherHome(uid: tid, name: tname)));
    } else {
      displayToastMessage("New user has not been Created", context);
    }
  }

  movetolastScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => TeacherHome(uid: tid, name: tname)));
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}

class BackButtonWidget extends StatelessWidget {
  final String tid;
  final String tname;
  BackButtonWidget({Key key, @required this.tid, @required this.tname})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('images/app.png'))),
      child: Positioned(
          child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 20,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Register New Student',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          )
        ],
      )),
    );
  }
}
