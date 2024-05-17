import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitinbox/service/singleton/auth_service.dart';

Future<Map<String, dynamic>> deleteUser({required String uuid}) async {
  try {
    final documentRef = FirebaseFirestore.instance.collection('users').doc(AuthService.uuid);
    final documentSnapshot = await documentRef.get();

    List<dynamic> accounts = documentSnapshot.get("accounts");

    for (int index = 0; index < accounts.length; index++) {
      if (accounts[index]["uuid"] == uuid) {
        accounts.removeAt(index);
      }
    }

    await documentRef.update({"accounts": accounts});

    final emailDocRef = FirebaseFirestore.instance.collection("emails").doc(AuthService.uuid);

    try {
      await emailDocRef.update({uuid: FieldValue.delete()});
    } catch (e) {
      print(e.toString());
    }

    return {"result": true};
  } catch (e) {
    return {
      "result": false,
      "message": e.toString(),
    };
  }
}
