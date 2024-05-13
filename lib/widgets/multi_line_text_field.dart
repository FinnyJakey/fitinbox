import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MultiLineTextField extends StatelessWidget {
  const MultiLineTextField({
    super.key,
    required this.textEditingController,
    this.autofocus = false,
    this.inputFormatters,
    required this.onChanged,
    required this.hintText,
  });

  final TextEditingController textEditingController;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters; // FilteringTextInputFormatter.digitsOnly, MaskTextInputFormatter(mask: "###-####-####"),
  final void Function(String)? onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autofocus,
      controller: textEditingController,
      inputFormatters: inputFormatters,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      // maxLength: maxLength,
      minLines: 10,
      maxLines: null,
      // expands: true,
      onChanged: onChanged,
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
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFA2314),
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFA2314),
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        errorStyle: const TextStyle(
          letterSpacing: 0,
          color: Color(0xFFFA2314),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
