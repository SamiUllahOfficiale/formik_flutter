import 'package:flutter/material.dart';
import 'package:formik_flutter/formik_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Formik Flutter Example')),
        body: const Padding(padding: EdgeInsets.all(16.0), child: SimpleForm()),
      ),
    );
  }
}

class SimpleForm extends StatelessWidget {
  const SimpleForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Formik(
      initialValues: const {'email': ''},
      onSubmit: (values, formik) async {
        await Future.delayed(const Duration(seconds: 2));
        debugPrint('Form Submitted: $values');
        formik.resetForm();
      },
      builder: (context, formik) {
        final bool isButtonDisabled =
            !formik.isValid || !formik.isDirty || formik.isSubmitting;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormikField<String>(
              name: 'email',
              validator: FormikValidators.compose([
                FormikValidators.required(message: 'Email is required'),
                FormikValidators.email(message: 'Enter a valid email'),
              ]),
              builder: (context, value, onChanged, errorText) {
                return FormikTextField(
                  value: value ?? '',
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    errorText: errorText,
                    border: const OutlineInputBorder(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isButtonDisabled
                        ? null
                        : () => formik.handleSubmit(),
                    child: formik.isSubmitting
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Submit'),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: (!formik.isDirty || formik.isSubmitting)
                      ? null
                      : () => formik.resetForm(),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
