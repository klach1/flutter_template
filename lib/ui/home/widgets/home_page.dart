import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../viewmodels/home_viewmodel.dart';

class MyHomePage extends HookWidget {
  const MyHomePage({super.key, required this.viewmodel});
  final HomeViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    final viewmodel = this.viewmodel;

    // Define _onLoad function before using it
    void _onLoad() {
      if (viewmodel.loadActivities.completed) {
        viewmodel.loadActivities.clearResult();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Activities loaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }

      if (viewmodel.loadActivities.error) {
        viewmodel.loadActivities.clearResult();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Activities load failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    // Use useEffect for lifecycle methods (similar to initState and dispose)
    useEffect(() {
      // This runs on mount (similar to initState)
      viewmodel.loadActivities.addListener(_onLoad);

      // Return a cleanup function (similar to dispose)
      return () {
        viewmodel.loadActivities.removeListener(_onLoad);
      };
    }, [viewmodel]); // Dependency array - will re-run if viewmodel changes

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Home'),
        surfaceTintColor: Colors.white,
      ),
      backgroundColor:
          Colors.white, // Adding white background color to the Scaffold
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
                await viewmodel.loadActivities.execute('recreational');
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
}
