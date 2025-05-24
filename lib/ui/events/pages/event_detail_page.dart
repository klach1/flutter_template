import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodels/event_detail_viewmodel.dart';
import '../../../domain/models/events/user.dart';
import '../../../domain/models/events/chat_message.dart';
import '../../../domain/models/events/event_note.dart';

class EventDetailPage extends StatefulWidget {
  final String eventId;

  const EventDetailPage({Key? key, required this.eventId}) : super(key: key);

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Load initial data using the provided ViewModel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventDetailViewModel>().loadEventDetail();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail události'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Info'),
            Tab(text: 'Chat'),
            Tab(text: 'Uživatelé'),
            Tab(text: 'Poznámky'),
          ],
        ),
      ),
      body: Consumer<EventDetailViewModel>(
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
                  Text(viewModel.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.loadEventDetail(),
                    child: const Text('Zkusit znovu'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.event == null) {
            return const Center(child: Text('Událost nebyla nalezena'));
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildInfoTab(context, viewModel),
              _buildChatTab(context, viewModel),
              _buildUsersTab(context, viewModel),
              _buildNotesTab(context, viewModel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoTab(BuildContext context, EventDetailViewModel viewModel) {
    final event = viewModel.event!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(event.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Event Title
          Text(
            event.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Category
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: Text(
              event.category.displayName,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            'Popis události',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            event.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          
          // Date and Time
          _buildInfoCard(
            context,
            icon: Icons.access_time,
            title: 'Datum a čas',
            content: '${DateFormat('dd.MM.yyyy HH:mm').format(event.startDateTime)} - ${DateFormat('dd.MM.yyyy HH:mm').format(event.endDateTime)}',
          ),
          const SizedBox(height: 12),
          
          // Location
          _buildInfoCard(
            context,
            icon: Icons.location_on,
            title: 'Místo',
            content: event.location.address,
          ),
          const SizedBox(height: 12),
          
          // Participants
          _buildInfoCard(
            context,
            icon: Icons.people,
            title: 'Účastníci',
            content: event.participantsText,
          ),
          const SizedBox(height: 12),
          
          // Pilots
          _buildInfoCard(
            context,
            icon: Icons.flight,
            title: 'Piloti',
            content: event.pilotsText,
          ),
          const SizedBox(height: 20),
          
          // Action buttons row
          Row(
            children: [
              // Add to calendar button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _addToCalendar(context, event),
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Přidat do kalendáře'),
                ),
              ),
              const SizedBox(width: 12),
              // Edit button (only for organizers)
              if (event.isUserOrganizer) // TODO: Implement this property
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editEvent(context, event),
                    icon: const Icon(Icons.edit),
                    label: const Text('Upravit'),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Tasks section (only for organizers)
          if (event.isUserOrganizer) // TODO: Implement this property
            _buildTasksSection(context, viewModel),
          
          const SizedBox(height: 20),
          
          // Registration Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: event.isUserRegistered
                  ? () => _handleUnregister(context, viewModel)
                  : () => _handleRegister(context, viewModel),
              style: ElevatedButton.styleFrom(
                backgroundColor: event.isUserRegistered 
                    ? Colors.red 
                    : Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                event.isUserRegistered ? 'Odhlásit se' : 'Přihlásit se',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRegister(BuildContext context, EventDetailViewModel viewModel) async {
    // Use placeholder user ID - this should come from authentication service
    const userId = 'user-001';
    
    final success = await viewModel.registerForEvent(userId);
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Úspěšně jste se přihlásili na událost'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.error ?? 'Nepodařilo se přihlásit na událost'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleUnregister(BuildContext context, EventDetailViewModel viewModel) async {
    // Use placeholder user ID - this should come from authentication service
    const userId = 'user-001';
    
    final success = await viewModel.unregisterFromEvent(userId);
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Úspěšně jste se odhlásili z události'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.error ?? 'Nepodařilo se odhlásit z události'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildChatTab(BuildContext context, EventDetailViewModel viewModel) {
    // Load chat messages when tab is opened
    if (viewModel.chatMessages.isEmpty && !viewModel.isLoadingMessages) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadChatMessages();
      });
    }

    return Column(
      children: [
        Expanded(
          child: viewModel.isLoadingMessages
              ? const Center(child: CircularProgressIndicator())
              : viewModel.chatMessages.isEmpty
                  ? const Center(
                      child: Text(
                        'Zatím nejsou žádné zprávy.\nBuďte první, kdo začne konverzaci!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      reverse: true, // Show newest messages at bottom
                      padding: const EdgeInsets.all(16),
                      itemCount: viewModel.chatMessages.length,
                      itemBuilder: (context, index) {
                        final message = viewModel.chatMessages[index];
                        return _buildChatMessage(context, message, viewModel);
                      },
                    ),
        ),
        _buildChatInput(context, viewModel),
      ],
    );
  }

  Widget _buildChatMessage(BuildContext context, ChatMessage message, EventDetailViewModel viewModel) {
    // This would typically come from user service
    const currentUserId = 'user-001';
    final isCurrentUser = message.userId == currentUserId;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Text(
                message.userId[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isCurrentUser 
                    ? Theme.of(context).primaryColor
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: isCurrentUser ? const Radius.circular(20) : const Radius.circular(4),
                  bottomRight: isCurrentUser ? const Radius.circular(4) : const Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('HH:mm').format(message.timestamp),
                    style: TextStyle(
                      color: isCurrentUser 
                          ? Colors.white.withOpacity(0.7)
                          : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isCurrentUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Text(
                'U',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChatInput(BuildContext context, EventDetailViewModel viewModel) {
    final controller = TextEditingController();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Napište zprávu...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            mini: true,
            onPressed: () => _sendMessage(context, viewModel, controller),
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(BuildContext context, EventDetailViewModel viewModel, TextEditingController controller) async {
    final message = controller.text.trim();
    if (message.isEmpty) return;

    // Clear input immediately
    controller.clear();
    
    // Use placeholder user ID - this should come from authentication service
    const userId = 'user-001';
    
    final success = await viewModel.sendChatMessage(userId, message);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.error ?? 'Nepodařilo se odeslat zprávu'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildUsersTab(BuildContext context, EventDetailViewModel viewModel) {
    // Load participants when tab is opened
    if (viewModel.participants.isEmpty && !viewModel.isLoadingParticipants) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadParticipants();
      });
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pilots Section
          Text(
            'Piloti (${viewModel.pilots.length})',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          if (viewModel.isLoadingParticipants)
            const Center(child: CircularProgressIndicator())
          else if (viewModel.pilots.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Zatím nejsou zaregistrovaní žádní piloti'),
              ),
            )
          else
            ...viewModel.pilots.map((pilot) => _buildUserCard(context, pilot, isPilot: true)),
          
          const SizedBox(height: 24),
          
          // Participants Section
          Text(
            'Účastníci (${viewModel.participants.length})',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          if (viewModel.isLoadingParticipants)
            const Center(child: CircularProgressIndicator())
          else if (viewModel.participants.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Zatím nejsou zaregistrovaní žádní účastníci'),
              ),
            )
          else
            ...viewModel.participants.map((participant) => _buildUserCard(context, participant)),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, User user, {bool isPilot = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPilot ? Colors.blue : Colors.green,
          child: Text(
            user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user.fullName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(user.email),
        trailing: isPilot 
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'PILOT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildNotesTab(BuildContext context, EventDetailViewModel viewModel) {
    // Load notes when tab is opened
    if (viewModel.eventNotes.isEmpty && !viewModel.isLoadingNotes) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadEventNotes();
      });
    }

    return Column(
      children: [
        Expanded(
          child: viewModel.isLoadingNotes
              ? const Center(child: CircularProgressIndicator())
              : viewModel.eventNotes.isEmpty
                  ? const Center(
                      child: Text(
                        'Zatím nejsou žádné poznámky.\nVytvořte první poznámku!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: viewModel.eventNotes.length,
                      itemBuilder: (context, index) {
                        final note = viewModel.eventNotes[index];
                        return _buildNoteCard(context, note);
                      },
                    ),
        ),
        _buildAddNoteButton(context, viewModel),
      ],
    );
  }

  Widget _buildNoteCard(BuildContext context, EventNote note) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  DateFormat('dd.MM.yyyy HH:mm').format(note.timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              note.content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.blue,
                  child: Text(
                    note.userId[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  note.userId,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNoteButton(BuildContext context, EventDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _showAddNoteDialog(context, viewModel),
          icon: const Icon(Icons.add),
          label: const Text('Přidat poznámku'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddNoteDialog(BuildContext context, EventDetailViewModel viewModel) async {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nová poznámka'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Název poznámky',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Obsah poznámky',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Zrušit'),
            ),
            ElevatedButton(
              onPressed: () => _createNote(
                context,
                viewModel,
                titleController.text.trim(),
                contentController.text.trim(),
              ),
              child: const Text('Vytvořit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createNote(
    BuildContext context,
    EventDetailViewModel viewModel,
    String title,
    String content,
  ) async {
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Název i obsah poznámky musí být vyplněny'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.of(context).pop(); // Close dialog
    
    // Use placeholder user ID - this should come from authentication service
    const userId = 'user-001';
    
    final success = await viewModel.createEventNote(userId, title, content);
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Poznámka byla úspěšně vytvořena'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.error ?? 'Nepodařilo se vytvořit poznámku'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Missing methods for the new functionality
  Widget _buildTasksSection(BuildContext context, EventDetailViewModel viewModel) {
    final event = viewModel.event!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Úkoly',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        // Task progress overview
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.task_alt, color: Theme.of(context).primaryColor),
              const SizedBox(width: 12),
              Text(
                'Stav příprav: ${event.tasksProgress}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Task list
        ...event.tasks.map((task) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: task.isCompleted ? Colors.green[50] : Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: task.isCompleted ? Colors.green[200]! : Colors.orange[200]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: task.isCompleted ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Switch(
                  value: task.isCompleted,
                  onChanged: (value) => _toggleTask(context, viewModel, task),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  void _toggleTask(BuildContext context, EventDetailViewModel viewModel, dynamic task) {
    // TODO: Implement task toggle functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Správa úkolů zatím není implementována')),
    );
  }

  void _addToCalendar(BuildContext context, dynamic event) async {
    // Create calendar event data
    final DateFormat dateFormat = DateFormat('yyyyMMddTHHmmss');
    final String startDate = dateFormat.format(event.startDateTime);
    final String endDate = dateFormat.format(event.endDateTime);
    
    // Create ICS content
    final String icsContent = '''BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Event Manager//Event Manager//CS
BEGIN:VEVENT
UID:${event.id}@eventmanager.app
DTSTART:${startDate}Z
DTEND:${endDate}Z
SUMMARY:${event.title}
DESCRIPTION:${event.description}
LOCATION:${event.location.address}
STATUS:CONFIRMED
SEQUENCE:0
END:VEVENT
END:VCALENDAR''';

    try {
      // For mobile platforms, we can try to open the default calendar app
      final Uri calendarUri = Uri(
        scheme: 'https',
        host: 'calendar.google.com',
        path: '/calendar/render',
        queryParameters: {
          'action': 'TEMPLATE',
          'text': event.title,
          'dates': '${startDate}Z/${endDate}Z',
          'details': event.description,
          'location': event.location.address,
        },
      );
      
      if (await canLaunchUrl(calendarUri)) {
        await launchUrl(calendarUri, mode: LaunchMode.externalApplication);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Událost byla přidána do kalendáře')),
          );
        }
      } else {
        throw 'Cannot launch calendar';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nepodařilo se otevřít kalendář. Zkuste to později.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  void _editEvent(BuildContext context, dynamic event) {
    // TODO: Implement edit event functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Úprava události zatím není implementována')),
    );
  }
}