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
    // Full screen map view without any event list below
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue[100]!,
            Colors.grey[200]!,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Full screen map placeholder with improved styling
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map_outlined, 
                  size: 80, 
                  color: Colors.blue,
                ),
                SizedBox(height: 20),
                Text(
                  'Mapové zobrazení událostí',
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Integrace s Google Maps bude přidána v další verzi',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Icon(
                  Icons.construction,
                  size: 32,
                  color: Colors.orange,
                ),
              ],
            ),
          ),
          
          // Event count overlay with improved styling
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.event,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${viewModel.events.length} událostí',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Filter status overlay (bottom left)
          if (viewModel.hasActiveFilters)
            Positioned(
              bottom: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.filter_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Filtry aktivní',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
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
