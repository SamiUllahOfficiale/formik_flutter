import 'package:flutter/material.dart';
import '../scopes/formik_scope.dart';

typedef FormikFieldValidator<T> = String? Function(T? value);

class FormikField<T> extends StatefulWidget {
  final String name;
  final FormikFieldValidator<T>? validator;
  final Widget Function(
    BuildContext context,
    T? value,
    ValueChanged<T?> onChanged,
    String? errorText,
  ) builder;

  const FormikField({
    super.key,
    required this.name,
    this.validator,
    required this.builder,
  });

  @override
  State<FormikField<T>> createState() => _FormikFieldState<T>();
}

class _FormikFieldState<T> extends State<FormikField<T>> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final formik = FormikScope.of(context);

    formik.registerFieldValidator(widget.name, () {
      final currentVal = formik.getValue(widget.name) as T?;
      return widget.validator?.call(currentVal);
    });
  }

  @override
  void dispose() {
    try {
      final formik = FormikScope.of(context);
      formik.unregisterFieldValidator(widget.name);
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formik = FormikScope.of(context);
    final currentValue = formik.getValue(widget.name) as T?;

    final isTouched = formik.touched[widget.name] ?? false;
    final rawError = formik.errors[widget.name];
    final displayError = isTouched ? rawError : null;

    return FormField<T>(
      initialValue: currentValue,
      builder: (fieldState) {
        return widget.builder(
          context,
          currentValue,
          (newValue) {
            fieldState.didChange(newValue);
            formik.setFieldValue(widget.name, newValue);
          },
          displayError,
        );
      },
    );
  }
}
