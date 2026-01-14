import 'package:flutter/material.dart';
import 'package:todo_app/widgets/custom_app_bar.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: Center(child: Text("User profile screen")),
    );
  }
}
