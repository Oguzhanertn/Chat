import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final double height;
  //final RegExp validationRegEx;
  final bool obscureText;
  final void Function(String?) onSaved;

  const CustomFormField({
    super.key,
    required this.hintText,
    required this.height,
    //required this.validationRegEx,
    required this.onSaved,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        onSaved: onSaved,
        obscureText: obscureText,
        // validator: (value) {
        //   if (value != null && validationRegEx.hasMatch(value)) {
        //     return null;
        //   }
        //   //return "Lütfen geçerli bir ${hintText.toLowerCase()} giriniz";
        // },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
