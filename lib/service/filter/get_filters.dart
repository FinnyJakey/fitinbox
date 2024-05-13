import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitinbox/service/singleton/auth_service.dart';

Future<Map<String, dynamic>> getFilters() async {
  try {
    final documentRef = FirebaseFirestore.instance.collection('users').doc(AuthService.uuid);
    final documentData = (await documentRef.get()).data()!;

    String name = documentData["filters"]["name"];
    List<dynamic> contentList = documentData["filters"]["contents"];

    String contents = contentList.join("\n");

    return {
      "result": true,
      "data": {
        "name": name,
        "contents": contents,
      },
    };
  } catch (e) {
    return {
      "result": false,
      "message": e.toString(),
    };
  }
}
