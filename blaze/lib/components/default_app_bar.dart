import 'package:blaze/components/styles/icon_broken.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
  required function,
}) =>
    AppBar(
      leading: IconButton(
        icon: const Icon(IconBroken.Arrow___Left_2),
        onPressed: function,
      ),
      titleSpacing: 5.0,
      title: title != null ? Text(title, style: Theme.of(context).textTheme.bodyText1) : null,
      actions: actions,
    );
