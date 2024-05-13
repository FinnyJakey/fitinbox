import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static late String id;
  static late String pw;
  static late String uuid;

  static final AuthService _instance = AuthService._internal();

  AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  static Future<void> initialize() async {
    await _instance._initAuth();
  }

  Future<void> _initAuth() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? idValue = await storage.read(key: "id");
    final String? pwValue = await storage.read(key: "pw");

    id = idValue ?? "";
    pw = pwValue ?? "";
    uuid = "";
  }

  static void changeUuid({required String toChangeUuid}) {
    uuid = toChangeUuid;
  }
}
