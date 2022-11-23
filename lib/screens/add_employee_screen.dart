import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test_sqlite_drift/notifier/employee_change_notifier.dart';

import '../data/local/db/app_db.dart';
import '../widget/custom_date_picker_form_field.dart';
import '../widget/custom_text_form_field.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  //
  // late AppDb _db;
  //

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  DateTime? dateOfBirth;

  final _formKey = GlobalKey<FormState>();

  late EmployeeChangeNotifier _employeeChangeNotifier;

  ///
  @override
  void initState() {
    super.initState();

    _employeeChangeNotifier =
        Provider.of<EmployeeChangeNotifier>(context, listen: false);
    _employeeChangeNotifier.addListener(providerListener);
  }

  ///
  @override
  void dispose() {
    userNameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    dateOfBirthController.dispose();

    _employeeChangeNotifier.dispose();

    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: addEmployee,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: userNameController,
                    txtLabel: 'User Name',
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: firstNameController,
                    txtLabel: 'First Name',
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: lastNameController,
                    txtLabel: 'Last Name',
                  ),
                  const SizedBox(height: 8),
                  CustomDatePickerFormField(
                    controller: dateOfBirthController,
                    txtLabel: 'Date of Birth',
                    callback: () => pickDateOfBirth(context: context),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  Future<void> pickDateOfBirth({required BuildContext context}) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateOfBirth ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 3),
      builder: (context, child) {
        return Theme(
          data: ThemeData().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.pinkAccent,
              ),
              dialogBackgroundColor: Colors.white),
          child: child ?? const Text(''),
        );
      },
    );

    if (newDate == null) {
      return;
    }

    setState(() {
      dateOfBirth = newDate;
      final dob = DateFormat('yyyy/MM/dd').format(newDate);
      dateOfBirthController.text = dob;
    });
  }

  ///
  void addEmployee() {
    final isValid = _formKey.currentState?.validate();

    if (isValid != null && isValid) {
      final entity = EmployeeCompanion(
        userName: drift.Value(userNameController.text),
        firstName: drift.Value(firstNameController.text),
        lastName: drift.Value(lastNameController.text),
        dateOfBirth: drift.Value(dateOfBirth!),
      );

      context.read<EmployeeChangeNotifier>().createEmployee(entity);

      //
      // providerListener();
      //

      /*
      Provider.of<AppDb>(context, listen: false).insertEmployee(entity).then(
            (value) =>
            ScaffoldMessenger.of(context).showMaterialBanner(
              MaterialBanner(
                backgroundColor: Colors.deepOrangeAccent,
                content: Text(
                  'New Employee inserted. $value',
                  style: const TextStyle(color: Colors.white),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                    },
                    child: const Text(
                      'close',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
      );
      */

      //
      // _db.insertEmployee(entity).then(
      //       (value) => ScaffoldMessenger.of(context).showMaterialBanner(
      //         MaterialBanner(
      //           backgroundColor: Colors.deepOrangeAccent,
      //           content: Text(
      //             'New Employee inserted. $value',
      //             style: const TextStyle(color: Colors.white),
      //           ),
      //           actions: [
      //             TextButton(
      //               onPressed: () {
      //                 ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      //               },
      //               child: const Text(
      //                 'close',
      //                 style: TextStyle(color: Colors.white),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //

    }
  }

  ///
  void providerListener() {
    if (_employeeChangeNotifier.isAdded) {
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          backgroundColor: Colors.deepOrangeAccent,
          content: const Text(
            'New Employee inserted.',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: const Text(
                'close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }
}
