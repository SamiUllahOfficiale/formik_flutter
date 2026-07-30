# formik_flutter

A lightweight, declarative form state management solution for Flutter, inspired by Formik.

## Features

- **Declarative Form State**: Easily access `values`, `errors`, and `touched` field states.
- **Form Status Tracking**: Out-of-the-box support for `isValid`, `isDirty`, and `isSubmitting`.
- **Pre-Validation**: Automatic validation check prior to form submission.
- **Built-in & Custom Validators**: Includes standard field validators (`required`, `email`, `minLength`, `maxLength`, `matches`, `custom`) with composition support.
- **Clean Initial Render**: Un-touched fields defer error displays until modified or submitted.
- **Form Reset**: One-line resetting back to initial values (`formik.resetForm()`).

## Getting Started

Add `formik_flutter` to your `pubspec.yaml` file:

```yaml
dependencies:
  formik_flutter: ^0.0.1
```

Or run this command in your terminal:

```bash
flutter pub add formik_flutter
```

## Usage

Here is a full working example showing how to build a simple form with validation using Formik:

```dart
Formik(
  initialValues: const {'email': ''},
  onSubmit: (values, formik) async {
    formik.resetForm();
  },
  builder: (context, formik) {
    return FormikField<String>(
      name: 'email',
      validator: FormikValidators.required(),
      builder: (context, value, onChanged, errorText) {
        return FormikTextField(
          value: value ?? '',
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: errorText,
          ),
        );
      },
    );
  },
);
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.
