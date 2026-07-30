import 'package:flutter/material.dart';
import 'package:formik_flutter/formik_flutter.dart';

class FormikScope extends InheritedNotifier<FormikController> {
  const FormikScope({
    super.key,
    required FormikController controller,
    required super.child,
  }) : super(notifier: controller);

  static FormikController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<FormikScope>();
    assert(scope != null, 'No FormikScope found in context');
    return scope!.notifier!;
  }
}
