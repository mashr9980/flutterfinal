import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

//for save user in firebase
Future<void> userSetup(String displayName) async {
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid.toString();
  users.add({'displayName': displayName, "uid": uid});
  return;
}

class DatabaseManager {
  final CollectionReference user =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference studets =
      FirebaseFirestore.instance.collection('student');

  Future getUserList() async {
    List itemList = [];
    try {
      await user.getDocuments().then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          itemList.add(element.data());
          //print(itemList);
        });
      });
      return itemList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getallstudentList() async {
    List itemList = [];
    try {
      await studets.getDocuments().then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          itemList.add(element.data());
        });
      });
      return itemList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

class PermissionService {
  final PermissionHandler _permissionHandler = PermissionHandler();

  Future<bool> _requestPermission() async {
    var result =
        await _permissionHandler.requestPermissions([PermissionGroup.storage]);
    if (result == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> requestPermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission();
    if (!granted) {
      onPermissionDenied();
    }
    return granted;
  }
}
