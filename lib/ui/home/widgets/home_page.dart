import 'package:flutter/material.dart';
import '../../../domain/exceptions/dividable_exception.dart';
import '../../../utils/result.dart';
import '../viewmodels/home_viewmodel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.viewmodel});
  final HomeViewmodel viewmodel;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final viewmodel = widget.viewmodel;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListenableBuilder(
              listenable: viewmodel.incrementCounter,
              builder: (context, _) {
                if (viewmodel.incrementCounter.running) {
                  return CircularProgressIndicator();
                } else if (viewmodel.incrementCounter.error) {
                  return Text(viewmodel.incrementCounter.result.toString());
                } else {
                  return Text(
                    widget.viewmodel.counter.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewmodel.incrementCounter.execute,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
