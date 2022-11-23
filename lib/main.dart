import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:test_sqlite_drift/notifier/employee_change_notifier.dart';

import 'data/local/db/app_db.dart';
import 'routes/route_generator.dart';

void main() {
//  runApp(const MyApp());

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: AppDb()),

        //
        ChangeNotifierProxyProvider<AppDb, EmployeeChangeNotifier>(
            create: (context) => EmployeeChangeNotifier(),
            update: (context, db, notifier) => notifier!
              ..initAppDb(db)
              ..getEmployeeFuture()),
            
        // update: (context, db, notifier) => notifier!
        //   ..initAppDb(db)
        //   ..getEmployeeStream()),

        //
      ],
      child: const MyApp(),
    ),

    // Provider(
    //   create: (context) => AppDb(),
    //   child: const MyApp(),
    //   dispose: (context, AppDb db) => db.close(),
    // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
