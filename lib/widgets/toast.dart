import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showBooleanToast(BuildContext context, {required bool granted, required String message}) {
  FToast fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.only(left: 12.0, right: 20.0, top: 10.5, bottom: 10.5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6.0),
      color: const Color(0xFF212124),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/svg/toast/${granted ? 'check' : 'slash-circle-01'}.svg',
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 8.0),
        Text(
          message,
          style: const TextStyle(
            letterSpacing: 0,
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.TOP,
    toastDuration: const Duration(seconds: 1, milliseconds: 500),
  );
}
