
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final controller;
  final hintText;
  final vadidationText;
  final isObsure;
  final keyboardType;
  final inputFormaters;
  const CustomTextField({
    super.key, this.controller, this.hintText, this.vadidationText, this.isObsure, this.keyboardType, this.inputFormaters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObsure,
      style: TextStyle(color: Colors.white),
      inputFormatters: 
        inputFormaters
      ,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
      ),
      cursorColor: Colors.white,
      validator: (value) => value!.isEmpty ? vadidationText : null,
    );
  }
}
