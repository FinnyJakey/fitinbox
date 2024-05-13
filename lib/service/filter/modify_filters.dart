import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitinbox/service/singleton/auth_service.dart';

Future<Map<String, dynamic>> modifyFilters({required String name, required List<dynamic> contents}) async {
  try {
    final documentRef = FirebaseFirestore.instance.collection('users').doc(AuthService.uuid);

    final newData = {
      "filters": {
        "name": name,
        "contents": contents,
      },
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
