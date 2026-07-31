## 1.0.1

- Updated LICENSE format for pub.dev recognition.
- Added dartdoc documentation across public classes and members.
- **Breaking Change**: Transitioned to a completely headless builder architecture using `FormikField`.
- Added support for dynamic key-path resolution (`user.profile.name`, `users.0.name`).
- Added support for dynamic form arrays (repeatable container fields).
- Integrated dual-level validation engine (Field-level & Form-level schema validation).
- Added automatic `TextEditingController` state sync inside `FormikField`.
