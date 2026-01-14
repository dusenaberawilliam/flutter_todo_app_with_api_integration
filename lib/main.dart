import 'package:flutter/material.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/view_models/todo_view_model.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 251, 251, 251),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
