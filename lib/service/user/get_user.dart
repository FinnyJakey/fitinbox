import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitinbox/service/singleton/auth_service.dart';

Future<Map<String, dynamic>> getUser() async {
  try {
    final documentRef = FirebaseFirestore.instance.collection('users').doc(AuthService.uuid);
    final documentData = (await documentRef.get()).data()!;

    final List<dynamic> accounts = documentData["accounts"];

    return {
      "result": true,
      "data": accounts,
    };
  } catch (e) {
    return {
      "result": false,
      "message": e.toString(),
    };
  }
}
