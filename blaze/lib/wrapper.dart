import 'package:blaze/views/login/login_screen.dart';
import 'package:blaze/views/social_layout/social_layout.dart';
import 'package:flutter/material.dart';

class Wrapper {
  static Widget start({String? uId, bool? onBarding}) {
    
    Widget? startWidget;
    
    if (uId == null) {
      startWidget = SocialLogin();
    } else {
      startWidget = SocialLayout();
    }
    return startWidget;
  }
}
