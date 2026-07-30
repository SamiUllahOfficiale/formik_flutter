import 'package:flutter_test/flutter_test.dart';
import 'package:formik_flutter/formik_flutter.dart';

void main() {
  test('FormikValidators required validator test', () {
    final validator = FormikValidators.required();
    expect(validator(''), 'This field is required');
    expect(validator('valid text'), null);
  });
}
