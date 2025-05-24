import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/events_viewmodel.dart';
import '../widgets/event_card.dart';

class EventsMapPage extends StatefulWidget {
  const EventsMapPage({Key? key}) : super(key: key);

  @override
  State<EventsMapPage> createState() => _EventsMapPageState();
}

class _EventsMapPageState extends State<EventsMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa událostí'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Zpět na seznam',
          ),
        ],
      ),
      body: Consumer<EventsViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Chyba při načítání událostí',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    viewModel.error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.loadEvents(),
                    child: const Text('Zkusit znovu'),
                  ),
                ],
              ),
            );
          }

          return _buildMapView(context, viewModel);
        },
      ),
    );
  }

  Widget _buildMapView(BuildContext context, EventsViewModel viewModel) {
    // TODO: Implement actual map view with Google Maps or similar
    // For now, showing a full screen map placeholder
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[300],
      child: Stack(
        children: [
          // Full screen map placeholder
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Mapové zobrazení',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Implementace Google Maps bude přidána později'),
              ],
            ),
          ),
          
          // Event count overlay in top right
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${viewModel.events.length} událostí',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRegistration(
    BuildContext context,
    EventsViewModel viewModel,
    String eventId,
  ) async {
    // TODO: Get current user ID from auth service
    const currentUserId = 'usr_001'; // Placeholder

    final event = viewModel.getEventById(eventId);
    if (event == null) return;

    bool success;
    if (event.isUserRegistered) {
      success = await viewModel.unregisterFromEvent(eventId, currentUserId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Úspěšně odhlášeno z události')),
        );
      }
    } else {
      success = await viewModel.registerForEvent(eventId, currentUserId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Úspěšně přihlášeno na událost')),
        );
      }
    }

    if (!success && viewModel.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.error!)),
      );
      viewModel.clearError();
    }
  }

  void _navigateToEventDetail(BuildContext context, String eventId) {
    Navigator.pushNamed(context, '/$eventId');
  }
}
