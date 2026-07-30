import 'package:flutter/material.dart';
import 'package:formik_flutter/formik_flutter.dart';

class Formik extends StatefulWidget {
  final Map<String, dynamic> initialValues;
  final FormikSubmitCallback? onSubmit;
  final Widget Function(BuildContext context, FormikController formik) builder;

  const Formik({
    super.key,
    this.initialValues = const {},
    this.onSubmit,
    required this.builder,
  });

  @override
  State<Formik> createState() => _FormikState();
}

class _FormikState extends State<Formik> {
  late FormikController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FormikController(
      initialValues: widget.initialValues,
      onSubmit: widget.onSubmit,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormikScope(
      controller: _controller,
      child: Builder(
        builder: (context) {
          final controller = FormikScope.of(context);
          return widget.builder(context, controller);
        },
      ),
    );
  }
}
