import 'package:flutter/material.dart';

Widget defaultTextButton({
  required Function() function,
  required String text,
}) =>
    TextButton(
      onPressed: function,
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w600
        ),
      ),
    );
