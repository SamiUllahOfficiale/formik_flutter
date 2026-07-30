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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dynamic Form Array Example'),
          centerTitle: true,
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: DynamicUsersForm(),
        ),
      ),
    );
  }
}

class DynamicUsersForm extends StatefulWidget {
  const DynamicUsersForm({super.key});

  @override
  State<DynamicUsersForm> createState() => _DynamicUsersFormState();
}

class _DynamicUsersFormState extends State<DynamicUsersForm> {
  late final FormikController _formik;

  @override
  void initState() {
    super.initState();

    _formik = FormikController(
      initialValues: {
        'users': [
          {
            'name': '',
            'email': '',
            'role': 'Developer',
            'isActive': true,
          }
        ]
      },
      onSubmit: (values) {
        debugPrint('Submitted Values: $values');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Successfully Submitted ${values['users'].length} Users!'),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _formik.dispose();
    super.dispose();
  }

  void _addUserCard() {
    final currentList = List<Map<String, dynamic>>.from(
      _formik.getFieldValue<List>('users') ?? [],
    );

    currentList.add({
      'name': '',
      'email': '',
      'role': 'Developer',
      'isActive': true,
    });

    _formik.setFieldValue('users', currentList);
  }

  void _removeUserCard(int index) {
    final currentList = List<Map<String, dynamic>>.from(
      _formik.getFieldValue<List>('users') ?? [],
    );

    if (currentList.length > 1) {
      currentList.removeAt(index);
      _formik.setFieldValue('users', currentList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Formik(
      controller: _formik,
      child: AnimatedBuilder(
        animation: _formik,
        builder: (context, _) {
          final usersList = _formik.getFieldValue<List>('users') ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Users Count (${usersList.length})',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addUserCard,
                    icon: const Icon(Icons.add),
                    label: const Text('Add User'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: usersList.length,
                itemBuilder: (context, index) {
                  return Container(
                    key: ValueKey('user_container_$index'),
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'User #${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (usersList.length > 1)
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline,
                                    color: Colors.red),
                                onPressed: () => _removeUserCard(index),
                              ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        FormikField<String>(
                          name: 'users.$index.name',
                          validator: FormikValidators.required(
                              message: 'Name is required'),
                          builder: (context, field) {
                            return TextFormField(
                              controller: field.controller,
                              onChanged: field.didChange,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: const OutlineInputBorder(),
                                errorText: field.isTouched ? field.error : null,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        FormikField<String>(
                          name: 'users.$index.email',
                          validator: FormikValidators.compose([
                            FormikValidators.required(
                                message: 'Email is required'),
                            FormikValidators.email(message: 'Invalid email'),
                          ]),
                          builder: (context, field) {
                            return TextFormField(
                              controller: field.controller,
                              onChanged: field.didChange,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: const OutlineInputBorder(),
                                errorText: field.isTouched ? field.error : null,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        FormikField<String>(
                          name: 'users.$index.role',
                          validator: FormikValidators.required(),
                          builder: (context, field) {
                            return DropdownButtonFormField<String>(
                              initialValue: field.value,
                              decoration: const InputDecoration(
                                labelText: 'Role',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: 'Developer',
                                    child: Text('Developer')),
                                DropdownMenuItem(
                                    value: 'Designer', child: Text('Designer')),
                                DropdownMenuItem(
                                    value: 'Tester', child: Text('Tester')),
                              ],
                              onChanged: field.didChange,
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        FormikField<bool>(
                          name: 'users.$index.isActive',
                          builder: (context, field) {
                            return SwitchListTile(
                              title: const Text('Active Member'),
                              value: field.value ?? true,
                              onChanged: field.didChange,
                              contentPadding: EdgeInsets.zero,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: (!_formik.isValid || _formik.isSubmitting)
                    ? null
                    : () => _formik.submitForm(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Submit'),
              ),
            ],
          );
        },
      ),
    );
  }
}
