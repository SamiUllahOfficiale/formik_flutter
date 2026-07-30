import 'package:flutter/foundation.dart';
import '../utils/map_path.dart';

typedef FormikValidator<T> = String? Function(T? value);
typedef FormikSubmitHandler = void Function(Map<String, dynamic> values);

class FormikController extends ChangeNotifier {
  Map<String, dynamic> _values;
  final Map<String, dynamic> _initialValues;
  final Map<String, String?> _errors = {};
  final Set<String> _touched = {};
  final Map<String, FormikValidator<dynamic>> _fieldValidators = {};

  final Map<String, String?> Function(Map<String, dynamic> values)?
      validateForm;
  final FormikSubmitHandler? onSubmit;

  bool _isSubmitting = false;

  FormikController({
    required Map<String, dynamic> initialValues,
    this.validateForm,
    this.onSubmit,
  })  : _initialValues = Map<String, dynamic>.from(initialValues),
        _values = Map<String, dynamic>.from(initialValues) {
    validateAll();
  }

  Map<String, dynamic> get values => _values;
  Map<String, String?> get errors => Map.unmodifiable(_errors);
  Set<String> get touched => Set.unmodifiable(_touched);
  bool get isSubmitting => _isSubmitting;
  bool get isValid => _errors.values.every((err) => err == null);
  bool get isDirty => !mapEquals(_values, _initialValues);

  void registerFieldValidator(String name, FormikValidator<dynamic> validator) {
    _fieldValidators[name] = validator;
  }

  void unregisterFieldValidator(String name) {
    _fieldValidators.remove(name);
  }

  T? getFieldValue<T>(String name) {
    return MapPath.getIn(_values, name) as T?;
  }

  String? getFieldError(String name) => _errors[name];

  bool isFieldTouched(String name) => _touched.contains(name);

  void setFieldValue(String name, dynamic value, {bool shouldValidate = true}) {
    _values = MapPath.setIn(_values, name, value);
    markFieldTouched(name, shouldValidate: false);

    if (shouldValidate) {
      validateSingleField(name);
    }
    notifyListeners();
  }

  void markFieldTouched(String name, {bool shouldValidate = true}) {
    _touched.add(name);
    if (shouldValidate) {
      validateSingleField(name);
    }
    notifyListeners();
  }

  String? validateSingleField(String name) {
    String? error;

    final fieldValidator = _fieldValidators[name];
    if (fieldValidator != null) {
      final value = getFieldValue(name);
      error = fieldValidator(value);
    }

    if (error == null && validateForm != null) {
      final formErrors = validateForm!(_values);
      error = formErrors[name];
    }

    _errors[name] = error;
    notifyListeners();
    return error;
  }

  bool validateAll() {
    _errors.clear();

    _fieldValidators.forEach((name, validator) {
      final value = getFieldValue(name);
      final err = validator(value);
      if (err != null) {
        _errors[name] = err;
      }
    });

    if (validateForm != null) {
      final formErrors = validateForm!(_values);
      formErrors.forEach((key, err) {
        if (err != null) {
          _errors[key] = err;
        }
      });
    }

    notifyListeners();
    return isValid;
  }

  Future<void> submitForm() async {
    _touched.addAll(_fieldValidators.keys);

    final valid = validateAll();
    if (!valid) return;

    _isSubmitting = true;
    notifyListeners();

    try {
      onSubmit?.call(_values);
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void resetForm() {
    _values = Map<String, dynamic>.from(_initialValues);
    _errors.clear();
    _touched.clear();
    _isSubmitting = false;
    notifyListeners();
  }
}
