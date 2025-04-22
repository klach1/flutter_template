import 'package:flutter/material.dart';
import '../viewmodels/home_viewmodel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.viewmodel});
  final HomeViewmodel viewmodel;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    widget.viewmodel.loadActivities.addListener(_onLoad);
  }

  @override
  void dispose() {
    widget.viewmodel.loadActivities.removeListener(_onLoad);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewmodel.loadActivities.removeListener(_onLoad);
    widget.viewmodel.loadActivities.addListener(_onLoad);
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = widget.viewmodel;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Home'),
      ),
      body: ListenableBuilder(
        listenable: viewmodel.loadActivities,
        builder: (context, _) {
          if (viewmodel.loadActivities.running) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewmodel.loadActivities.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading activities: ${viewmodel.loadActivities.result}',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed:
                        () => viewmodel.loadActivities.execute('recreational'),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (viewmodel.activities.isEmpty) {
            // Handle case where loading succeeded but list is empty
            return Center(
              child: Column(
                children: [
                  Text(
                    'No activities found',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed:
                        () => viewmodel.loadActivities.execute('recreational'),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                await widget.viewmodel.loadActivities.execute('recreational');
              },
              child: ListView.builder(
                itemCount: viewmodel.activities.length,
                itemBuilder: (context, index) {
                  final activity = viewmodel.activities[index];
                  return ListTile(
                    title: Text(activity.activity),
                    subtitle: Text(
                      'Price: ${activity.price}, Participants: ${activity.participants}',
                    ),
                    // Add more details or actions as needed
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  void _onLoad() {
    if (widget.viewmodel.loadActivities.completed) {
      widget.viewmodel.loadActivities.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Activities loaded successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }

    if (widget.viewmodel.loadActivities.error) {
      widget.viewmodel.loadActivities.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Activities load failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
