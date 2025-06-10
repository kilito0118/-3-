import 'package:flutter/material.dart';

import 'icon_widgets.dart';
import 'text_style_form.dart';
import 'boxes_styles.dart';
import 'spacing_widgets.dart';

void showCustomAlert({
  required BuildContext context,
  required String title,
  required String message,
  required Widget child,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'CustomDialog',
    barrierColor: Colors.black.withAlpha(60),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SizedBox(); // 실 내용은 transitionBuilder에서 그림
    },
    transitionBuilder: (context, animation, secondaryAnimation, _) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutQuart,
        reverseCurve: Curves.easeOutCubic,
      );
      return Transform.scale(
        scale: curved.value,
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 26),
          backgroundColor: Colors.transparent,
          child: blurredBox(
            width: double.infinity,
            topRad: 20,
            bottomRad: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: contentsTitle(),
                  textAlign: TextAlign.center,
                ),
                spacingBoxMini(),
                Text(
                  message,
                  style: contentsDetail,
                  textAlign: TextAlign.center,
                ),
                spacingBox(),
                child,
              ],
            ),
          ),
        ),
      );
    },
  );
}

void showCustomDialog({
  required BuildContext context,
  required String title,
  required String message,
  required Widget child,
  IconData icon = Icons.check,
  Color color = Colors.black,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'CustomDialog',
    barrierColor: Colors.black.withAlpha(60),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SizedBox(); // 실 내용은 transitionBuilder에서 그림
    },
    transitionBuilder: (context, animation, secondaryAnimation, _) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutQuart,
        reverseCurve: Curves.easeOutCubic,
      );
      return Transform.scale(
        scale: curved.value,
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 26),
          backgroundColor: Colors.transparent,
          child: blurredBox(
            width: double.infinity,
            topRad: 20,
            bottomRad: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBlinkingIcon(
                  icon: icon,
                  color: color.withAlpha(20),
                  size: 120,
                ),
                spacingBox(),
                Text(title, style: contentsTitle()),
                spacingBoxMini(),
                Text(message, style: contentsDetail),
                spacingBox(),
                child,
              ],
            ),
          ),
        ),
      );
    },
  );
}
