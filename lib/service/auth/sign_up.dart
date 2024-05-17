import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

Future<Map<String, dynamic>> signUp({required String email, required String password, required String deviceToken}) async {
  try {
    String fitInboxEmail = "${email.split("@")[0]}@fitinbox.online";

    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final querySnapshot = await FirebaseFirestore.instance.collection("filters/").orderBy("createdAt", descending: false).limit(1).get();

    final sampleFilter = querySnapshot.docs.first.data();

    final String uuid = const Uuid().v4();

    await FirebaseFirestore.instance.collection("emails").doc(credential.user?.uid).set({
      uuid: [],
    });

    await FirebaseFirestore.instance.collection("users").doc(credential.user?.uid).set({
      "accounts": [
        {
          "email": fitInboxEmail,
          "recipient": email,
          "filters": {
            "name": sampleFilter["name"],
            "contents": sampleFilter["contents"],
          },
          "forwardScore": 8.0,
          "uuid": uuid,
        },
      ],
      "deviceToken": deviceToken,
    });

    const FlutterSecureStorage storage = FlutterSecureStorage();

    await storage.write(key: "id", value: email);
    await storage.write(key: "pw", value: password);

    return {"result": true};
  } on FirebaseAuthException catch (e) {
    return {
      "result": false,
      "message": e.code,
    };
  } catch (e) {
    return {
      "result": false,
      "message": e.toString(),
    };
  }
}
