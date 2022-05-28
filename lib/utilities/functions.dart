// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:velocity_x/velocity_x.dart';

abstract class Functions {
  static bool get isIos => Platform.isIOS;
  static bool get isAndroid => Platform.isAndroid;

  static String get platform {
    if (isIos) {
      return 'iOS';
    } else if (isAndroid) {
      return 'Android';
    }
    return 'Unknown';
  }

  static void showSnackBar(String message, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: Vx.black,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
