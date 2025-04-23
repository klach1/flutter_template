import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../viewmodel/user_viewmodel.dart';

class UserPage extends HookWidget {
  const UserPage({super.key, required this.viewmodel});
  final UserViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    final counter = useState(0);
    final viewmodel = this.viewmodel;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('User'),
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              viewmodel.username,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Counter: ${counter.value}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => counter.value++,
              child: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
