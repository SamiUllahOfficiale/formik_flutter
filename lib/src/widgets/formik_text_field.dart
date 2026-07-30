import 'package:flutter/material.dart';

class FormikTextField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final InputDecoration decoration;

  const FormikTextField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.decoration,
  });

  @override
  State<FormikTextField> createState() => _FormikTextFieldState();
}

class _FormikTextFieldState extends State<FormikTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant FormikTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: widget.decoration,
    );
  }
}
