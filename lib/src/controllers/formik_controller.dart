import 'package:flutter/foundation.dart';
import '../utils/map_path.dart';

/// Callback signature for field-level validation logic.
typedef FormikValidator<T> = String? Function(T? value);

/// Callback signature triggered upon form submission with current form values.
typedef FormikSubmitHandler = void Function(Map<String, dynamic> values);

/// Manages form state, validation, field registration, and submission logic.
class FormikController extends ChangeNotifier {
  Map<String, dynamic> _values;
  final Map<String, dynamic> _initialValues;
  final Map<String, String?> _errors = {};
  final Set<String> _touched = {};
  final Map<String, FormikValidator<dynamic>> _fieldValidators = {};

  /// Optional form-level schema validator function.
  final Map<String, String?> Function(Map<String, dynamic> values)?
      validateForm;

  /// Optional handler called when the form passes validation and is submitted.
  final FormikSubmitHandler? onSubmit;

  bool _isSubmitting = false;

  /// Creates a [FormikController] with initial values and optional validation/submission callbacks.
  FormikController({
    required Map<String, dynamic> initialValues,
    this.validateForm,
    this.onSubmit,
  })  : _initialValues = Map<String, dynamic>.from(initialValues),
        _values = Map<String, dynamic>.from(initialValues) {
    validateAll();
  }

  /// Returns a copy of the current form values map.
  Map<String, dynamic> get values => _values;

  /// Returns an unmodifiable view of current field validation errors.
  Map<String, String?> get errors => Map.unmodifiable(_errors);

  /// Returns an unmodifiable set of field names that have been marked as touched.
  Set<String> get touched => Set.unmodifiable(_touched);

  /// Indicates whether the form submission is currently in progress.
  bool get isSubmitting => _isSubmitting;

  /// Returns `true` if there are currently no validation errors across all fields.
  bool get isValid => _errors.values.every((err) => err == null);

  /// Returns `true` if current form values differ from initial values.
  bool get isDirty => !mapEquals(_values, _initialValues);

  /// Registers a validator function for a specific field name or path.
  void registerFieldValidator(String name, FormikValidator<dynamic> validator) {
    _fieldValidators[name] = validator;
  }

  /// Removes the registered validator function for a specific field name or path.
  void unregisterFieldValidator(String name) {
    _fieldValidators.remove(name);
  }

  /// Retrieves the value of a field at the given [name] path using dot notation.
  T? getFieldValue<T>(String name) {
    return MapPath.getIn(_values, name) as T?;
  }

  /// Retrieves the current validation error message for a given field [name].
  String? getFieldError(String name) => _errors[name];

  /// Returns `true` if the field [name] has been marked as touched.
  bool isFieldTouched(String name) => _touched.contains(name);

  /// Updates the value of a field at [name] and optionally triggers validation.
  void setFieldValue(String name, dynamic value, {bool shouldValidate = true}) {
    _values = MapPath.setIn(_values, name, value);
    markFieldTouched(name, shouldValidate: false);

    if (shouldValidate) {
      validateSingleField(name);
    }
    notifyListeners();
  }

  /// Marks a specific field [name] as touched and optionally triggers validation.
  void markFieldTouched(String name, {bool shouldValidate = true}) {
    _touched.add(name);
    if (shouldValidate) {
      validateSingleField(name);
    }
    notifyListeners();
  }

  /// Runs field-level and form-level validation for a single field [name].
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

  /// Validates all registered fields and form-level schemas, returning `true` if valid.
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

  /// Marks all registered fields as touched, validates the entire form, and calls [onSubmit] if valid.
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

  /// Resets the form state back to initial values and clears errors and touched fields.
  void resetForm() {
    _values = Map<String, dynamic>.from(_initialValues);
    _errors.clear();
    _touched.clear();
    _isSubmitting = false;
    notifyListeners();
  }
}
