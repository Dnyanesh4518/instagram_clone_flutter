import 'package:flutter/material.dart';
class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String inputHintText;
  final TextInputType textInputType;
  const TextFieldInput({super.key,required this.textEditingController,required this.textInputType,required this.inputHintText,this.isPass=false});

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context)
    );
    return Container(
      decoration: BoxDecoration(
        border:Border.all(width: 0.5),
        borderRadius: BorderRadius.circular(6)
      ),
      child: TextField(
        style: TextStyle(color: Colors.black),
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: inputHintText,
          hintStyle: TextStyle(color: Colors.grey),
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
          filled: true,
          contentPadding: EdgeInsets.all(8)
        ),

        keyboardType: textInputType,
        obscureText: isPass,
      ),
    );
  }
}
