import 'package:flutter/material.dart';
import 'package:formik_flutter/formik_flutter.dart';

class Formik extends InheritedNotifier<FormikController> {
  const Formik({
    super.key,
    required FormikController controller,
    required super.child,
  }) : super(notifier: controller);

  static FormikController of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<Formik>();
    assert(widget != null, 'No Formik widget found in context');
    return widget!.notifier!;
  }

  static FormikController? maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<Formik>();
    return widget?.notifier;
  }
}
