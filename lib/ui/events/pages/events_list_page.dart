import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/events/event_category.dart';
import '../viewmodels/events_viewmodel.dart';
import '../widgets/event_card.dart';
import 'events_map_page.dart';
import 'create_event_page.dart';

class EventsListPage extends StatefulWidget {
  const EventsListPage({Key? key}) : super(key: key);

  @override
  State<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  @override
  void initState() {
    super.initState();
    // Load events when the page is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventsViewModel>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Události'),
        actions: [
          Consumer<EventsViewModel>(
            builder: (context, viewModel, _) => viewModel.hasActiveFilters
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.red),
                    onPressed: () => viewModel.resetFilters(),
                    tooltip: 'Resetovat filtry',
                  )
                : const SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventsMapPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<EventsViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            children: [
              // Filters section
              _buildFiltersSection(context, viewModel),
              // Events list
              Expanded(
                child: _buildEventsList(context, viewModel),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateEventPage(),
            ),
          );
        },
        label: const Text('Vytvořit událost'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFiltersSection(BuildContext context, EventsViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Category filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...EventCategory.values
                    .map((category) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildCategoryChip(
                        context,
                        viewModel,
                        category,
                        category.displayName,
                        viewModel.selectedCategory == category,
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Date filters
          Row(
            children: [
              Expanded(
                child: _buildDateFilterButton(
                  context,
                  viewModel,
                  'Od',
                  viewModel.filterStartDate,
                  true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDateFilterButton(
                  context,
                  viewModel,
                  'Do',
                  viewModel.filterEndDate,
                  false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    EventsViewModel viewModel,
    EventCategory? category,
    String label,
    bool isSelected,
  ) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        viewModel.filterByCategory(selected ? category : null);
      },
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.3),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildDateFilterButton(
    BuildContext context,
    EventsViewModel viewModel,
    String label,
    DateTime? selectedDate,
    bool isStartDate,
  ) {
    return OutlinedButton(
      onPressed: () => _showDatePicker(context, viewModel, isStartDate),
      child: Text(
        selectedDate != null
            ? '${selectedDate.day}.${selectedDate.month}.${selectedDate.year}'
            : label,
      ),
    );
  }

  Future<void> _showDatePicker(
    BuildContext context,
    EventsViewModel viewModel,
    bool isStartDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (viewModel.filterStartDate ?? DateTime.now())
          : (viewModel.filterEndDate ?? DateTime.now()),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      if (isStartDate) {
        viewModel.filterByDateRange(picked, viewModel.filterEndDate);
      } else {
        viewModel.filterByDateRange(viewModel.filterStartDate, picked);
      }
    }
  }

  Widget _buildEventsList(BuildContext context, EventsViewModel viewModel) {
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

    final events = viewModel.events;

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_busy, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Žádné události nenalezeny',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Zkuste změnit filtry nebo přidat novou událost'),
            const SizedBox(height: 16),
            if (viewModel.hasActiveFilters)
              ElevatedButton(
                onPressed: () => viewModel.resetFilters(),
                child: const Text('Resetovat filtry'),
              ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.refreshEvents(),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80), // Space for FAB
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return EventCard(
            event: event,
            onRegisterPressed: () => _handleRegistration(context, viewModel, event.id),
            onDetailPressed: () => _navigateToEventDetail(context, event.id),
          );
        },
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
    context.go('/$eventId');
  }
}
