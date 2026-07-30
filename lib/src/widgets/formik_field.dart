import 'package:flutter/material.dart';
import '../controllers/formik_controller.dart';
import 'formik.dart';

class FormikFieldState<T> {
  final T? value;
  final String? error;
  final bool isTouched;
  final bool isDirty;
  final ValueChanged<T?> didChange;
  final TextEditingController? controller;

  FormikFieldState({
    required this.value,
    required this.error,
    required this.isTouched,
    required this.isDirty,
    required this.didChange,
    this.controller,
  });
}

typedef FormikFieldBuilder<T> = Widget Function(
  BuildContext context,
  FormikFieldState<T> field,
);

class FormikField<T> extends StatefulWidget {
  final String name;
  final FormikValidator<T>? validator;
  final FormikFieldBuilder<T> builder;

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
  FormikController? _controller;
  TextEditingController? _textController;

  @override
  void initState() {
    super.initState();
    if (T == String) {
      _textController = TextEditingController();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = Formik.of(context);
    if (_controller != controller) {
      _controller = controller;
      if (widget.validator != null) {
        _controller!.registerFieldValidator(
          widget.name,
          (val) => widget.validator!(val as T?),
        );
      }

      if (_textController != null) {
        final val = _controller!.getFieldValue<String>(widget.name) ?? '';
        if (_textController!.text != val) {
          _textController!.text = val;
        }
      }
    }
  }

  @override
  void dispose() {
    _controller?.unregisterFieldValidator(widget.name);
    _textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Formik.of(context);
    final value = controller.getFieldValue<T>(widget.name);
    final error = controller.getFieldError(widget.name);
    final isTouched = controller.isFieldTouched(widget.name);

    if (_textController != null &&
        value is String &&
        _textController!.text != value) {
      _textController!.text = value;
      _textController!.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController!.text.length),
      );
    }

    final fieldState = FormikFieldState<T>(
      value: value,
      error: error,
      isTouched: isTouched,
      isDirty: controller.isDirty,
      controller: _textController,
      didChange: (T? newValue) {
        controller.setFieldValue(widget.name, newValue);
      },
    );

    return widget.builder(context, fieldState);
  }
}
