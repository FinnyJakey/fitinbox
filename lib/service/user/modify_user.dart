import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitinbox/service/singleton/auth_service.dart';

Future<Map<String, dynamic>> modifyUser({required String uuid, required Map<String, dynamic> filters, required String email, required String recipient, required num score}) async {
  try {
    final documentRef = FirebaseFirestore.instance.collection('users').doc(AuthService.uuid);
    final documentSnapshot = await documentRef.get();

    List<dynamic> accounts = documentSnapshot.get("accounts");

    for (int index = 0; index < accounts.length; index++) {
      if (accounts[index]["uuid"] == uuid) {
        accounts[index] = {
          "email": "$email@fitinbox.online",
          "filters": filters,
          "forwardScore": score,
          "recipient": recipient,
          "uuid": uuid,
        };
      }
    }

    await documentRef.update({"accounts": accounts});

    return {"result": true};
  } catch (e) {
    return {
      "result": false,
      "message": e.toString(),
    };
  }
}
