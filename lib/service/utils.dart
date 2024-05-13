import 'dart:convert';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;

bool isValidEmailFormat(String? email) {
  if (email == null || email.isEmpty) {
    return false;
  }

  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+").hasMatch(email);
}

String getFromText({required String from}) {
  String originalString = from;

  // 정규 표현식을 사용하여 문자열 변경
  String modifiedString = originalString.replaceAllMapped(RegExp(r'"(.*?)"\s*<([^>]+)>'), (match) => "${match.group(1)}");

  // 큰따옴표 제거
  modifiedString = modifiedString.replaceAll('"', '');

  return modifiedString;
}

String getDetailFromText({required String from}) {
  String originalString = from;

  // 정규 표현식을 사용하여 문자열 변경
  String modifiedString = originalString.replaceAllMapped(RegExp(r'"(.*?)"\s*<([^>]+)>'), (match) => "${match.group(1)} ${match.group(2)}");

  // 큰따옴표 제거
  modifiedString = modifiedString.replaceAll('"', '');

  return modifiedString;
}

String getElapsedTime(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);
  if (difference.inMinutes < 1) {
    return '방금 전';
  } else if (difference.inHours < 1) {
    return '${difference.inMinutes} 분전';
  } else if (difference.inDays < 1) {
    return '${difference.inHours} 시간 전';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}일 전';
  } else if (date.year == now.year) {
    return '${date.month.toString().padLeft(2, '0')}월 ${date.day.toString().padLeft(2, '0')}일';
  } else {
    return '${date.year}년 ${date.month.toString().padLeft(2, '0')}월 ${date.day.toString().padLeft(2, '0')}일';
  }
}

String getKorDate(DateTime date) {
  return "${date.year}년 ${date.month}월 ${date.day}일 ${date.hour}:${date.minute}";
}

String getEmailText(String htmlText) {
  htmlDom.Document document = htmlParser.parse(htmlText);

  return extractTextWithoutTags(document.body!);
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String extractTextWithoutTags(htmlDom.Node node) {
  String text = "";

  // 현재 노드의 자식 노드를 순회하며 텍스트를 추출
  for (final childNode in node.nodes) {
    if (childNode.nodeType == htmlDom.Node.TEXT_NODE) {
      // 텍스트 노드인 경우 텍스트를 추가
      text += (childNode as htmlDom.Text).data;
    } else if (childNode.nodeType == htmlDom.Node.ELEMENT_NODE) {
      // 요소 노드인 경우 재귀적으로 탐색하여 텍스트를 추출
      text += extractTextWithoutTags(childNode);
    }
  }

  return text;
}
