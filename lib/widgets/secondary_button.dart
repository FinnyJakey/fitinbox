import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, this.disabled = false, required this.color, required this.title, required this.onPressed});

  final String title;
  final Color color;
  final bool disabled;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.zero,
      disabledColor: const Color(0xFFEAEBEE),
      color: color,
      pressedOpacity: 0.5,
      onPressed: disabled ? null : onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            letterSpacing: 0,
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
