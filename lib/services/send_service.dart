import 'package:flutter/material.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

Future<void> shareViaEmail() async {
  // final Email email = Email(
  //   subject: 'Expense Report',
  //   recipients: [
  //     'recipient@example.com'
  //   ], // Replace with the recipient's email address
  //   isHTML: false,
  //   body: 'Here is my expense report:',
  //   attachmentPaths: <String>[], // Add paths to image files here
  // );
  //
  // try {
  //   await FlutterEmailSender.send(email);
  // } catch (error) {
  //   print('Error sending email: $error');
  // }
}

Future<void> shareViaSMS() async {
  List<String> recipients = [
    '+260973178558'
  ]; // Replace with the recipient's phone number
  String message = 'Here is my expense report:\n\n';
}
