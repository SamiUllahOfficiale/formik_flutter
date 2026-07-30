import 'package:flutter/material.dart';

typedef FormikSubmitCallback = void Function(
  Map<String, dynamic> values,
  FormikController formik,
);

class FormikController extends ChangeNotifier {
  final Map<String, dynamic> initialValues;
  final FormikSubmitCallback? onSubmit;

  final Map<String, dynamic> _values = {};
  final Map<String, String?> _errors = {};
  final Map<String, bool> _touched = {};
  final Map<String, String? Function()> _fieldValidators = {};

  bool _isSubmitting = false;

  FormikController({
    this.initialValues = const {},
    this.onSubmit,
  }) {
    _values.addAll(initialValues);
  }

  Map<String, dynamic> get values => Map.unmodifiable(_values);
  Map<String, String?> get errors => Map.unmodifiable(_errors);
  Map<String, bool> get touched => Map.unmodifiable(_touched);
  bool get isSubmitting => _isSubmitting;

  bool get isValid => _errors.values.every((error) => error == null);

  bool get isDirty {
    for (final key in _values.keys) {
      final initialVal = initialValues[key] ?? '';
      final currentVal = _values[key] ?? '';
      if (currentVal != initialVal) return true;
    }
    return false;
  }

  dynamic getValue(String name) => _values[name];

  void registerFieldValidator(String name, String? Function() validator) {
    _fieldValidators[name] = validator;
    _errors[name] = validator();
  }

  void unregisterFieldValidator(String name) {
    _fieldValidators.remove(name);
    _errors.remove(name);
  }

  void setFieldValue(String name, dynamic value) {
    _values[name] = value;
    _touched[name] = true;

    if (_fieldValidators.containsKey(name)) {
      _errors[name] = _fieldValidators[name]!();
    }

    notifyListeners();
  }

  void setFieldTouched(String name, [bool isTouched = true]) {
    _touched[name] = isTouched;
    notifyListeners();
  }

  void setFieldError(String name, String? error) {
    _errors[name] = error;
    notifyListeners();
  }

  bool validateForm() {
    bool hasErrors = false;
    _fieldValidators.forEach((name, validator) {
      final error = validator();
      _errors[name] = error;
      _touched[name] = true;
      if (error != null) {
        hasErrors = true;
      }
    });
    notifyListeners();
    return !hasErrors;
  }

  Future<void> handleSubmit() async {
    final formIsValid = validateForm();
    if (!formIsValid) return;

    _isSubmitting = true;
    notifyListeners();

    try {
      if (onSubmit != null) {
        onSubmit!(_values, this);
      }
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void resetForm() {
    _values.clear();
    _values.addAll(initialValues);
    _touched.clear();
    _errors.clear();
    _isSubmitting = false;

    _fieldValidators.forEach((name, validator) {
      _errors[name] = validator();
    });

    notifyListeners();
  }
}
