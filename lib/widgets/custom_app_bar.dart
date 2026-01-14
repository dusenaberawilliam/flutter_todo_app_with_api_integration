import 'package:flutter/material.dart';
import 'package:todo_app/screens/user_profile_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.canPop(context);

    return AppBar(
      backgroundColor: const Color.fromARGB(255, 251, 251, 251),
      title: const Text('Tasks'),
      leading: canGoBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              iconSize: 17.0,
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const UserProfileScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
