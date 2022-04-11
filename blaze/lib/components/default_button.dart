import 'package:flutter/material.dart';
import 'package:blaze/components/const.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = defaultColor1,
  bool isUpperCase = true,
  double radius = 10.0,
  Gradient? gradient,
  required Function() function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        gradient: gradient,
        color: background,
      ),
    );
