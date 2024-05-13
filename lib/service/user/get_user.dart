import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitinbox/service/singleton/auth_service.dart';

Future<Map<String, dynamic>> getUser() async {
  try {
    final documentRef = FirebaseFirestore.instance.collection('users').doc(AuthService.uuid);
    final documentData = (await documentRef.get()).data()!;

    String emailName = documentData["email"].split("@")[0];
    String recipient = documentData["recipient"];
    num forwardScore = documentData["forwardScore"];

    return {
      "result": true,
      "data": {
        "emailName": emailName,
        "recipient": recipient,
        "forwardScore": forwardScore,
      },
    };
  } catch (e) {
    return {
      "result": false,
      "message": e.toString(),
    };
  }
}
