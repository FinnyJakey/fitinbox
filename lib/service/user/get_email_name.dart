import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitinbox/service/singleton/auth_service.dart';

Future<Map<String, dynamic>> getEmailName({required String emailUuid}) async {
  try {
    final documentRef = FirebaseFirestore.instance.collection('users').doc(AuthService.uuid);
    final documentData = (await documentRef.get()).data()!;

    final List<dynamic> accounts = documentData["accounts"];

    String emailName = "";

    for (final account in accounts) {
      if (account["uuid"] == emailUuid) {
        emailName = account["email"].split("@")[0];
      }
    }

    return {
      "result": true,
      "data": emailName,
    };
  } catch (e) {
    return {
      "result": false,
      "message": e.toString(),
    };
  }
}
