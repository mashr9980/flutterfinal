import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'auth_helper.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'TeacherAfterLogin.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

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
  double percentage = 0.1;

  String _fname, myfilename, fileName;
  File file;
  List l = [];

  _AssignmnetTeacherSideState(this.tid, this.sid, this.tName);

  @override
  void initState() {
    // TODO: implement initState
    getfiledata();
    super.initState();
    _fname = "";
  }

  Future getFile() async {
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    file = await FilePicker.getFile(type: FileType.ANY);
    fileName = '${randomName}';
    setState(() {
      _fname = basename(file.path);
    });
    print('${file.readAsBytesSync()}' + " --- " + file.toString());
  }

  Future Uploadfile(List<int> asset) async {
    await Firebase.initializeApp();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putData(asset);

    String url =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    print(url);
    documentFileUpload(url);
    return url;
  }

  void documentFileUpload(String str) {
    var data = {
      "tid": tid,
      "sid": sid,
      "tname": tName,
      "filename": myfilename,
      "check": "assign",
      "file": str,
      "datetime": DateFormat('yyyy-MM-dd \t kk:mm:ss')
          .format(DateTime.now())
          .toString(),
    };
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentReference ref = _firestore.collection("assignment").doc();
    ref.set(data).then((v) {
      Fluttertoast.showToast(
          msg: "Uploaded file",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_LEFT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    });
    getfiledata();
  }

  Future permissionAcessPhone() {
    PermissionService().requestPermission(onPermissionDenied: () {
      print('Permission has been denied');
    });
  }

  downloadFile(String url, String f) async {
    permissionAcessPhone();
    String path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    print("path :  --  : " + path);
    FlutterDownloader.enqueue(
      url: url,
      savedDir: path,
      fileName: f,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }

  getfiledata() async {
    await Firebase.initializeApp();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    CollectionReference ref = _firestore.collection("assignment");
    QuerySnapshot userRef = await ref.get();
    l = userRef.docs.toList();
    print(l);
    setState(() {});
  }

  Widget filenamebox(String filename, String tname, String date, String link) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          border: Border.all(
        width: 2.0,
        color: Colors.teal,
      )),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  filename,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  date,
                  textAlign: TextAlign.right,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  tname,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(bottom: 20.0, right: 20.0),
            child: IconButton(
                icon: Icon(
                  Icons.cloud_download_outlined,
                  size: 60,
                ),
                onPressed: () {
                  downloadFile(link, filename);
                }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        movetolastScreen();
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.upload_file),
                  text: "Uploading Assignment",
                ),
                Tab(
                  icon: Icon(Icons.cloud_upload_outlined),
                  text: "List of Assignments",
                ),
                Tab(
                  icon: Icon(Icons.cloud_download_outlined),
                  text: "Student Submitted file",
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => TeacherHome(uid: tid, name: tName)));
              },
            ),
            title: Text('Asssignment Upload'),
            backgroundColor: Color(0xFF00a79B),
          ),
          body: TabBarView(
            children: [
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      children: [
                        Center(
                          child: (_fname != "")
                              ? Container(
                                  child: Text(
                                    "File: " + _fname,
                                  ),
                                )
                              : Container(),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 40,
                              width: 150,
                              child: RaisedButton(
                                onPressed: () {
                                  getFile();
                                },
                                color: Colors.tealAccent[700],
                                child: Text(
                                  'Choose file',
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
                    SizedBox(
                      height: 15.0,
                    ),
                    Center(
                      child: Container(
                          margin: EdgeInsets.only(right: 20, left: 10),
                          child: TextField(
                            onChanged: (value) {
                              myfilename = value;
                            },
                            decoration:
                                InputDecoration(hintText: 'Assignment Name*'),
                          )),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 40,
                          width: 150,
                          child: RaisedButton(
                            onPressed: () {
                              if (myfilename == "" || _fname == "") {
                                Fluttertoast.showToast(
                                    msg: "Enter Required Field",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM_RIGHT,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 15.0);
                              } else
                                Uploadfile(file.readAsBytesSync());
                            },
                            color: Colors.tealAccent[700],
                            child: Text(
                              'Upload',
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
              // Center(
              (l.length > 0)
                  ? ListView.builder(
                      itemCount: l.length,
                      itemBuilder: (context, index) {
                        if (l[index].get("tid") == tid &&
                            l[index].get("sid") == sid &&
                            l[index].get("check") == "assign") {
                          return filenamebox(
                              l[index].get("filename"),
                              "Teacher: " + l[index].get("tname"),
                              l[index].get("datetime"),
                              l[index].get("file"));
                        }
                        return Container();
                      },
                    )
                  : Center(
                      child: Container(
                        child: Text('No assignment Assigned'),
                      ),
                    ),
              (l.length > 0)
                  ? ListView.builder(
                      itemCount: l.length,
                      itemBuilder: (context, index) {
                        if (l[index].get("tid") == tid &&
                            l[index].get("sid") == sid &&
                            l[index].get("check") == "submit") {
                          return filenamebox(
                              l[index].get("filename"),
                              "Student: " + l[index].get("tname"),
                              l[index].get("datetime"),
                              l[index].get("file"));
                        }
                        return Container();
                      },
                    )
                  : Center(
                      child: Container(
                        child: Text('No assignment Submitted'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  movetolastScreen() {
    Navigator.of(this.context).pushReplacement(MaterialPageRoute(
        builder: (context) => TeacherHome(uid: tid, name: tName)));
  }
}
