import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitinbox/service/singleton/auth_service.dart';
import 'package:uuid/uuid.dart';

Future<Map<String, dynamic>> addUser({required String email, required Map<String, dynamic> filters, required num score, required String recipient}) async {
  try {
    final documentRef = FirebaseFirestore.instance.collection('users').doc(AuthService.uuid);
    final documentData = (await documentRef.get()).data()!;

    final List<dynamic> accounts = documentData["accounts"];

    final String uuid = const Uuid().v4();

    accounts.add(
      {
        "email": "$email@fitinbox.online",
        "filters": filters,
        "forwardScore": score,
        "recipient": recipient,
        "uuid": uuid,
      },
    );

    await documentRef.update({
      "accounts": accounts,
    });

    final emailDocRef = FirebaseFirestore.instance.collection('emails').doc(AuthService.uuid);

    await emailDocRef.update({
      uuid: [],
    });

    return {"result": true};
  } catch (e) {
    return {
      "result": false,
      "message": e.toString(),
    };
  }
}
