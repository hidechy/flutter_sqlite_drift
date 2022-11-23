// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:flutter/material.dart';

import '../data/local/db/app_db.dart';

class EmployeeChangeNotifier extends ChangeNotifier {
  AppDb? _appDb;

  ///
  void initAppDb(AppDb db) {
    _appDb = db;
  }

  ///

  String _error = '';

  String get error => _error;

  ///

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ///

  List<EmployeeData> _employeeListFuture = [];

  List<EmployeeData> get employeeListFuture => _employeeListFuture;

  void getEmployeeFuture() {
    _isLoading = true;

    _appDb?.getEmployees().then((value) {
      _employeeListFuture = value;

      _isLoading = false;

      notifyListeners();
    }).onError((error, stackTrace) {
      _error = error.toString();

      _isLoading = false;

      notifyListeners();
    });

    // notifyListeners();
  }

  ///

  List<EmployeeData> _employeeListStream = [];

  List<EmployeeData> get employeeListStream => _employeeListStream;

  void getEmployeeStream() {
    _isLoading = true;
    _appDb?.getEmployeeStream().listen((event) {
      _employeeListStream = event;
    });

    _isLoading = false;
    notifyListeners();
  }

  ///

  EmployeeData? _employeeData;

  EmployeeData? get employeeData => _employeeData;

  void getSingleEmployee(int id) {
    _appDb?.getEmployee(id).then((value) {
      _employeeData = value;
    }).onError((error, stackTrace) {
      _error = error.toString();
    });

    notifyListeners();
  }

  ///

  bool _isAdded = false;

  bool get isAdded => _isAdded;

  void createEmployee(EmployeeCompanion entity) {
    _appDb?.insertEmployee(entity).then((value) {
      _isAdded = (value == 1) ? true : false;
    }).onError((error, stackTrace) {
      _error = error.toString();
    });

    notifyListeners();
  }

  ///

  bool _isUpdated = false;

  bool get isUpdated => _isUpdated;

  void updateEmployee(EmployeeCompanion entity) {
    _appDb?.updateEmployee(entity).then((value) {
      _isUpdated = value;
    }).onError((error, stackTrace) {
      _error = error.toString();
    });

    notifyListeners();
  }

  ///

  bool _isDeleted = false;

  bool get isDeleted => _isDeleted;

  void deleteEmployee(int id) {
    _appDb?.deleteEmployee(id).then((value) {
      _isDeleted = (value == 1) ? true : false;
    }).onError((error, stackTrace) {
      _error = error.toString();
    });

    notifyListeners();
  }
}
