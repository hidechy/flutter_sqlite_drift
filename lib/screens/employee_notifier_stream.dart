import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_sqlite_drift/data/local/db/app_db.dart';
import 'package:test_sqlite_drift/notifier/employee_change_notifier.dart';

//import '../data/local/db/app_db.dart';

class EmployeeNotifierStreamScreen extends StatefulWidget {
  const EmployeeNotifierStreamScreen({super.key});

  @override
  State<EmployeeNotifierStreamScreen> createState() =>
      _EmployeeNotifierStreamScreenState();
}

class _EmployeeNotifierStreamScreenState
    extends State<EmployeeNotifierStreamScreen> {
  ///
  @override
  void initState() {
    super.initState();
  }

  ///
  @override
  void dispose() {
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    //
    // final employees =
    //     context.watch<EmployeeChangeNotifier>().employeeListStream;
    //

    return Scaffold(
        appBar: AppBar(
          title: const Text('Employee Notifier Stream'),
          centerTitle: true,
        ),
        body: Selector<EmployeeChangeNotifier, List<EmployeeData>>(
          selector: (context, notifier) => notifier.employeeListStream,
          builder: (context, employees, child) {
            return ListView.separated(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/edit_employee',
                      arguments: employees[index].id,
                    );
                  },
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.green,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(employees[index].id.toString()),
                          Text(
                            employees[index].userName,
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            employees[index].firstName,
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            employees[index].lastName,
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            employees[index].dateOfBirth.toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => Container(),
              itemCount: employees.length,
            );
          },
        )

        /*
      ListView.separated(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/edit_employee',
                arguments: employees[index].id,
              );
            },
            child: Card(
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.green,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(employees[index].id.toString()),
                    Text(
                      employees[index].userName,
                      style: const TextStyle(color: Colors.black),
                    ),
                    Text(
                      employees[index].firstName,
                      style: const TextStyle(color: Colors.black),
                    ),
                    Text(
                      employees[index].lastName,
                      style: const TextStyle(color: Colors.black),
                    ),
                    Text(
                      employees[index].dateOfBirth.toString(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => Container(),
        itemCount: employees.length,
      ),
*/

        /*

      body: FutureBuilder<List<EmployeeData>>(
        //
        // future: _db.getEmployees(),
        //

        future: Provider.of<AppDb>(context, listen: false).getEmployees(),

        builder: (context, snapshot) {
          final employees = snapshot.data;

          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (employees != null) {
            return ListView.separated(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/edit_employee',
                      arguments: employees[index].id,
                    );
                  },
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.green,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(employees[index].id.toString()),
                          Text(
                            employees[index].userName,
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            employees[index].firstName,
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            employees[index].lastName,
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            employees[index].dateOfBirth.toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => Container(),
              itemCount: employees.length,
            );
          }

          return const Text('No Data');
        },
      ),

      */
        );
  }
}
