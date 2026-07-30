# Formik Flutter

An enterprise-grade, headless form state management library for Flutter, inspired by Formik.

## Features

- 🚀 **Headless Builder Pattern**: Full UI freedom using `FormikField`.
- 🌐 **Dot-Notation Path Resolution**: Easily read/write nested maps (`user.profile.name`) and dynamic array paths (`users.0.email`).
- ⚡ **Dynamic Form Arrays**: Add, remove, and validate repeatable form cards seamlessly.
- 🎯 **Dual Validation**: Supports both field-level validators and form-level schema functions.
- 🔄 **Reactive State Sync**: Built-in automatic `TextEditingController` lifecycle management.

## Quick Start

```dart
final formik = FormikController(
  initialValues: {'email': ''},
  onSubmit: (values) => print(values),
);

Formik(
  controller: formik,
  child: FormikField<String>(
    name: 'email',
    validator: FormikValidators.email(),
    builder: (context, field) {
      return TextFormField(
        controller: field.controller,
        onChanged: field.didChange,
        decoration: InputDecoration(
          labelText: 'Email',
          errorText: field.isTouched ? field.error : null,
        ),
      );
    },
  ),
);
```
