import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> getTemplates() async {
  try {
    final documentRefs = await FirebaseFirestore.instance.collection('filters').orderBy("createdAt").get();
    final documentRefsData = documentRefs.docs;

    List<Map<String, dynamic>> templates = [];

    for (final documentData in documentRefsData) {
      templates.add({
        "name": documentData.data()["name"],
        "contents": documentData.data()["contents"],
      });
    }

    return {
      "result": true,
      "data": {
        "templates": templates,
      },
    };
  } catch (e) {
    return {
      "result": false,
      "message": e.toString(),
    };
  }
}
