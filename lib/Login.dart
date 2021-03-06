import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:home_work_lutter_app/main.dart';
import 'TeacherAfterLogin.dart';
import 'AdminAfterLogin.dart';
import 'HomeScreen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
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
            SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  IconButton(icon: Icon(Icons.person), onPressed: null),
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
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.lock), onPressed: null),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(right: 20, left: 10),
                          child: TextField(
                            obscureText: true,
                            controller: passwordTextEditingController,
                            decoration: InputDecoration(hintText: 'Password'),
                          ))),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 60,
                  child: RaisedButton(
                    onPressed: () {
                      if (!emailTextEditingController.text.contains("@")) {
                        displayToastMessage(
                            'Email Address is not Valid', context);
                      } else if (passwordTextEditingController.text.isEmpty) {
                        displayToastMessage('Password is Necessary', context);
                      } else {
                        loginAuthenticationUser(context);
                      }
                    },
                    color: Color(0xFF00a79B),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAuthenticationUser(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((erMsg) {
      displayToastMessage("Error " + erMsg.toString(), context);
    }))
        .user;

    DocumentSnapshot variable = await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .get();

    if (firebaseUser != null) {
      userResf.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap != null &&
            firebaseUser.uid == 'nduzJUsE5aac9wNvIQyEuHCQ0IW2') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AdminHome()));
          displayToastMessage(
              "Congratulations Your logged successfully", context);
        } else if (variable['Type'] == 'Teacher') {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => TeacherHome(
                  uid: firebaseUser.uid, name: firebaseUser.displayName)));
          displayToastMessage(
              "Congratulations Your logged successfully", context);
        } else {
          _firebaseAuth.signOut();
          displayToastMessage("Not Record found this user", context);
        }
      });
    } else {
      displayToastMessage("Error exist", context);
    }
  }

  movetolastScreen() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    Key key,
  }) : super(key: key);

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
                'Welcome to Login',
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
