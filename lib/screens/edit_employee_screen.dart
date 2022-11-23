import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test_sqlite_drift/notifier/employee_change_notifier.dart';

import '../data/local/db/app_db.dart';
import '../widget/custom_date_picker_form_field.dart';
import '../widget/custom_text_form_field.dart';

class EditEmployeeScreen extends StatefulWidget {
  const EditEmployeeScreen({super.key, required this.id});

  final int id;

  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  late DateTime dateOfBirth;

  late EmployeeData _employeeData;

  final _formKey = GlobalKey<FormState>();

  late EmployeeChangeNotifier _employeeChangeNotifier;

  ///
  @override
  void initState() {
    super.initState();

    _employeeChangeNotifier =
        Provider.of<EmployeeChangeNotifier>(context, listen: false);
    _employeeChangeNotifier.addListener(providerListener);

    getEmployee();
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
        title: const Text('Edit Employee'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: editEmployee,
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: deleteEmployee,
            icon: const Icon(Icons.delete),
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
  void deleteEmployee() {
    context.read<EmployeeChangeNotifier>().deleteEmployee(widget.id);

    //
    // listenDelete();
    //

    /*
    Provider.of<AppDb>(context, listen: false).deleteEmployee(widget.id).then(
          (value) => ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              backgroundColor: Colors.deepOrangeAccent,
              content: Text(
                'Employee deleted. $value',
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
    // _db.deleteEmployee(widget.id).then(
    //       (value) => ScaffoldMessenger.of(context).showMaterialBanner(
    //         MaterialBanner(
    //           backgroundColor: Colors.deepOrangeAccent,
    //           content: Text(
    //             'Employee deleted. $value',
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
  }

  ///
  void providerListener() {
    if (_employeeChangeNotifier.isUpdated) {
      listenUpdate();
    }

    if (_employeeChangeNotifier.isDeleted) {
      listenDelete();
    }
  }

  ///
  void listenDelete() {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor: Colors.deepOrangeAccent,
        content: const Text(
          'Employee deleted.',
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

  ///
  void listenUpdate() {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor: Colors.deepOrangeAccent,
        content: const Text(
          'Employee updated.',
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

  ///
  Future<void> pickDateOfBirth({required BuildContext context}) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateOfBirth,
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
  void editEmployee() {
    final isValid = _formKey.currentState?.validate();

    if (isValid != null && isValid) {
      final entity = EmployeeCompanion(
        id: drift.Value(widget.id),
        userName: drift.Value(userNameController.text),
        firstName: drift.Value(firstNameController.text),
        lastName: drift.Value(lastNameController.text),
        dateOfBirth: drift.Value(dateOfBirth),
      );

      context.read<EmployeeChangeNotifier>().updateEmployee(entity);

      //
      // listenUpdate();
      //

      /*
      Provider.of<AppDb>(context, listen: false).updateEmployee(entity).then(
            (value) => ScaffoldMessenger.of(context).showMaterialBanner(
              MaterialBanner(
                backgroundColor: Colors.deepOrangeAccent,
                content: Text(
                  'Employee updated. $value',
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
      // _db.updateEmployee(entity).then(
      //       (value) => ScaffoldMessenger.of(context).showMaterialBanner(
      //         MaterialBanner(
      //           backgroundColor: Colors.deepOrangeAccent,
      //           content: Text(
      //             'Employee updated. $value',
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
  Future<void> getEmployee() async {
    _employeeData =
        await Provider.of<AppDb>(context, listen: false).getEmployee(widget.id);

    //
    // _employeeData = await _db.getEmployee(widget.id);
    //

    userNameController.text = _employeeData.userName;
    firstNameController.text = _employeeData.firstName;
    lastNameController.text = _employeeData.lastName;
    dateOfBirthController.text = _employeeData.dateOfBirth.toIso8601String();

    dateOfBirth = _employeeData.dateOfBirth;
  }
}
