typedef FormikValidator = String? Function(dynamic value);

class FormikValidators {
  static FormikValidator compose(List<FormikValidator> validators) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }

  static FormikValidator required({String? message}) {
    return (value) {
      final defaultMessage = message ?? 'This field is required';
      if (value == null) return defaultMessage;
      if (value is String && value.trim().isEmpty) return defaultMessage;
      if (value is bool && !value) return defaultMessage;
      if (value is Iterable && value.isEmpty) return defaultMessage;
      if (value is Map && value.isEmpty) return defaultMessage;
      return null;
    };
  }

  static FormikValidator email({String? message}) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    );

    return (value) {
      if (value == null) return null;
      final str = value.toString().trim();
      if (str.isEmpty) return null;

      final defaultMessage = message ?? 'Invalid email address';
      return emailRegex.hasMatch(str) ? null : defaultMessage;
    };
  }

  static FormikValidator minLength(int min, {String? message}) {
    return (value) {
      if (value == null) return null;
      final str = value.toString();
      if (str.isEmpty) return null;

      return str.length < min
          ? (message ?? 'Must be at least $min characters')
          : null;
    };
  }

  static FormikValidator maxLength(int max, {String? message}) {
    return (value) {
      if (value == null) return null;
      final str = value.toString();
      if (str.isEmpty) return null;

      return str.length > max
          ? (message ?? 'Cannot exceed $max characters')
          : null;
    };
  }

  static FormikValidator matches(RegExp regex, {required String message}) {
    return (value) {
      if (value == null) return null;
      final str = value.toString();
      if (str.isEmpty) return null;

      return regex.hasMatch(str) ? null : message;
    };
  }

  static FormikValidator custom(
    bool Function(dynamic value) predicate, {
    required String message,
  }) {
    return (value) {
      if (value == null) return null;
      if (value is String && value.trim().isEmpty) return null;

      try {
        return predicate(value) ? null : message;
      } catch (_) {
        return message;
      }
    };
  }
}
