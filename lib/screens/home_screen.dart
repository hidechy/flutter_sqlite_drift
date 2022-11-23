import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_sqlite_drift/notifier/employee_change_notifier.dart';
import 'package:test_sqlite_drift/screens/employee_notifier_future.dart';
import 'package:test_sqlite_drift/screens/employee_notifier_stream.dart';

//
// import '../data/local/db/app_db.dart';
//

// import 'employee_future.dart';
// import 'employee_stream.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  final pages = [
    // const EmployeeFutureScreen(),

    const EmployeeNotifierFutureScreen(),

//    const EmployeeStreamScreen(),
    const EmployeeNotifierStreamScreen(),
  ];

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
    return Scaffold(
      body: pages[index],

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add_employee');
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Employee'),
      ),

      //
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          if (value == 1) {
            context.read<EmployeeChangeNotifier>().getEmployeeStream();
          }

          setState(() {
            index = value;
          });
        },
        backgroundColor: Colors.blue.shade300,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white30,
        showSelectedLabels: false,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            activeIcon: Icon(Icons.list_outlined),
            label: 'Employee Future',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            activeIcon: Icon(Icons.list_outlined),
            label: 'Employee Stream',
          ),
        ],
      ),
    );
  }
}
