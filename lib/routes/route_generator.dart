// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';

import '../screens/add_employee_screen.dart';
import '../screens/edit_employee_screen.dart';
import '../screens/home_screen.dart';

class RouteGenerator {
  ///
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case '/add_employee':
        return MaterialPageRoute(builder: (_) => const AddEmployeeScreen());
      case '/edit_employee':
        if (args is int) {
          return MaterialPageRoute(
              builder: (_) => EditEmployeeScreen(id: args));
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  ///
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('No Route'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            'No Route',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 18,
            ),
          ),
        ),
      );
    });
  }
}
