import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? inputAction;
  const CustomTextField({
    super.key,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.inputAction,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        prefixIcon ?? Container(),
        const SizedBox(width: 14),
        Expanded(
          child: TextFormField(


            cursorHeight: 18,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: inputAction,

            decoration: InputDecoration(
              hintText: hintText,
              focusedBorder: const UnderlineInputBorder(
              ),
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              suffixIcon: suffixIcon,
            ),


          ),
        ),
      ],
    );
  }
}