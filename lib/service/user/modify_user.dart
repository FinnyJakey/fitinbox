import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitinbox/service/singleton/auth_service.dart';

Future<Map<String, dynamic>> modifyUser({required String emailName, required String recipient, required double forwardScore}) async {
  try {
    final documentRef = FirebaseFirestore.instance.collection('users').doc(AuthService.uuid);

    final emailQuerySnapshot = await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: "$emailName@fitinbox.online").get();

    if (!("$emailName@fitinbox.online" == (await documentRef.get()).data()?["email"])) {
      if (emailQuerySnapshot.docs.isNotEmpty) {
        return {
          "result": false,
          "message": "fitinbox 이메일이 중복됩니다.",
        };
      }
    }

    final newData = {
      "email": "$emailName@fitinbox.online",
      "forwardScore": forwardScore,
      "recipient": recipient,
    };

    await documentRef.update(newData);

    return {"result": true};
  } catch (e) {
    return {
      "result": false,
      "message": e.toString(),
    };
  }
}
