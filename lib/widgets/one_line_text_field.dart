import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OneLineTextField extends StatelessWidget {
  const OneLineTextField({
    super.key,
    required this.textEditingController,
    this.autofocus = false,
    this.inputFormatters,
    this.maxLength,
    required this.onChanged,
    required this.hintText,
    this.keyboardType,
    this.suffixIcon,
    this.obscureText = false,
  });

  final TextEditingController textEditingController;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters; // FilteringTextInputFormatter.digitsOnly, MaskTextInputFormatter(mask: "###-####-####"),
  final int? maxLength;
  final void Function(String)? onChanged;
  final String hintText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autofocus,
      keyboardType: keyboardType,
      controller: textEditingController,
      inputFormatters: inputFormatters,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      onChanged: onChanged,
      maxLength: maxLength,
      obscureText: obscureText,
      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      cursorColor: const Color(0xFF212124),
      // cursorHeight: 18,
      style: const TextStyle(
        letterSpacing: 0,
        color: Color(0xFF212124),
        fontWeight: FontWeight.w400,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        counterText: "",
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        hintText: hintText,
        hintStyle: const TextStyle(
          letterSpacing: 0,
          color: Color(0xFF868B94),
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF212124),
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFD1D3D8),
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
