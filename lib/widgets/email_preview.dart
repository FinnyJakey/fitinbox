import 'dart:convert';

import 'package:fitinbox/service/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget emailPreview({required dynamic email, required void Function() onPressed}) {
  return CupertinoButton(
    minSize: 0,
    padding: EdgeInsets.zero,
    onPressed: onPressed,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          importanceWidget(reason: email["reason"], score: email["score"]),
          const SizedBox(height: 6),
          Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          size: 20,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            getFromText(from: jsonDecode(email["metadata"])["Records"][0]["ses"]["mail"]["commonHeaders"]["from"][0]),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          getElapsedTime((email["createdAt"].toDate())),
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      jsonDecode(email["metadata"])["Records"][0]["ses"]["mail"]["commonHeaders"]["subject"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      getEmailText(email["content"]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget importanceWidget({required String reason, required num score}) {
  return Row(
    children: [
      CircleAvatar(
        radius: 2.0,
        backgroundColor: importanceColor(score: score),
      ),
      const SizedBox(width: 8),
      Text(
        reason,
        style: TextStyle(
          fontSize: 12.0,
          color: importanceColor(score: score),
        ),
      ),
    ],
  );
}

Color importanceColor({required num score}) {
  if (score >= 7.5 && score <= 10.0) {
    return Colors.red;
  }

  if (score >= 5.0 && score <= 7.4) {
    return Colors.deepOrangeAccent.withOpacity(0.8);
  }

  if (score >= 2.5 && score <= 4.9) {
    return Colors.brown;
  }

  return Colors.grey;
}
