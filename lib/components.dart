import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MySizedBox extends SizedBox {
  MySizedBox({super.key, required super.child}) : super(width: double.infinity);
}

class MyElevatedButton extends ElevatedButton {
  MyElevatedButton({super.key, required String text, required super.onPressed})
      : super(child: Text(text));
}

String? stringNotEmptyValidator(value, message) {
  if (value == null || value.trim().isEmpty) {
    return message;
  }
  return null;
}

class MyText extends Text {
  const MyText(super.data, {super.key});
}

showNetworkErrorDialog(context, {message}) => showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
          content:
              MyText(message ?? 'Error while communicating with the server'),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: MyText('OK'))
          ],
        ));
