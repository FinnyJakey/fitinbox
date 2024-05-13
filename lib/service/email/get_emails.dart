import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitinbox/service/singleton/auth_service.dart';

Future<Map<String, dynamic>> getEmails() async {
  try {
    final documentRef = FirebaseFirestore.instance.collection('emails').doc(AuthService.uuid);
    final documentData = (await documentRef.get()).data()!;

    final List<dynamic> emailList = documentData["emails"];

    return {
      "result": true,
      "data": emailList.reversed.toList(),
    };
  } catch (e) {
    return {
      "result": false,
      "message": e.toString(),
    };
  }
}
