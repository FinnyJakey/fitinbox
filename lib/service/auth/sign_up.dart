import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<Map<String, dynamic>> signUp({required String email, required String password, required String deviceToken}) async {
  try {
    String docEmail = "${email.split("@")[0]}@fitinbox.online";

    final emailQuerySnapshot = await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: docEmail).get();

    if (emailQuerySnapshot.docs.isNotEmpty) {
      return {
        "result": false,
        "message": "fitinbox 이메일이 중복됩니다.",
      };
    }

    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final querySnapshot = await FirebaseFirestore.instance.collection("filters/").orderBy("createdAt", descending: false).limit(1).get();
    final sampleFilter = querySnapshot.docs.first.data();

    await FirebaseFirestore.instance.collection("emails").doc(credential.user?.uid).set({
      "emails": [],
    });

    await FirebaseFirestore.instance.collection("users").doc(credential.user?.uid).set({
      "email": docEmail,
      "recipient": email,
      "filters": {
        "name": sampleFilter["name"],
        "contents": sampleFilter["contents"],
      },
      "forwardScore": 8.0,
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
