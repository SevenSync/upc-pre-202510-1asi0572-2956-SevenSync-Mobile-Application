import 'package:flutter/material.dart';
import '../config/app_text_styles.dart';


class DialogHelper {
  static Future<void> showInfoDialog({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: AppTextStyles.headline2.copyWith(fontSize: 20)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content, style: AppTextStyles.bodyText1),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}