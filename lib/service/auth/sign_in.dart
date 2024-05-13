import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<Map<String, dynamic>> signIn({required String email, required String password}) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    const FlutterSecureStorage storage = FlutterSecureStorage();

    await storage.write(key: "id", value: email);
    await storage.write(key: "pw", value: password);

    return {
      "result": true,
      "uuid": credential.user?.uid,
    };
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
