import 'package:flutter/material.dart';

final FormFieldValidator<String> userNameValidator = (value) {
  if (value.isEmpty) return 'Name is required';
  if (value.length < 3) return 'Name is too short';
  if (value.length < 3) return 'Name is too short';
  final regName = RegExp(r'^[\w._]+$');
  if (!regName.hasMatch(value)) return 'Use words . or _';
  return null;
};
