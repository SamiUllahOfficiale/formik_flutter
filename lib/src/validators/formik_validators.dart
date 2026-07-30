import 'package:formik_flutter/formik_flutter.dart';

class FormikValidators {
  static FormikValidator<T> compose<T>(List<FormikValidator<T>> validators) {
    return (T? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }

  static FormikValidator<dynamic> required(
      {String message = 'This field is required'}) {
    return (value) {
      if (value == null) return message;
      if (value is String && value.trim().isEmpty) return message;
      if (value is Iterable && value.isEmpty) return message;
      if (value is Map && value.isEmpty) return message;
      return null;
    };
  }

  static FormikValidator<String> email(
      {String message = 'Invalid email address'}) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      if (!emailRegex.hasMatch(value)) return message;
      return null;
    };
  }

  static FormikValidator<String> minLength(int length, {String? message}) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length < length) {
        return message ?? 'Must be at least $length characters';
      }
      return null;
    };
  }

  static FormikValidator<String> pattern(RegExp pattern,
      {String message = 'Invalid format'}) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (!pattern.hasMatch(value)) return message;
      return null;
    };
  }
}
