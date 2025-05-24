import 'package:flutter/material.dart';
import '../../../domain/models/events/event_category.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({Key? key}) : super(key: key);

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _maxParticipantsController = TextEditingController();
  final _maxPilotsController = TextEditingController();
  
  EventCategory _selectedCategory = EventCategory.otevrene;
  DateTime _startDateTime = DateTime.now().add(const Duration(days: 1));
  DateTime _endDateTime = DateTime.now().add(const Duration(days: 1, hours: 2));

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    _maxParticipantsController.dispose();
    _maxPilotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vytvořit událost'),
        actions: [
          TextButton(
            onPressed: _saveEvent,
            child: const Text(
              'Uložit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Název události*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Název události je povinný';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Popis události*',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Popis události je povinný';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Category selection
              DropdownButtonFormField<EventCategory>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategorie*',
                  border: OutlineInputBorder(),
                ),
                items: EventCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              
              // Location field
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Adresa místa*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Adresa je povinná';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Image URL field
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL obrázku',
                  border: OutlineInputBorder(),
                  hintText: 'https://example.com/image.jpg',
                ),
              ),
              const SizedBox(height: 16),
              
              // Date and time section
              Row(
                children: [
                  Expanded(
                    child: _buildDateTimeField(
                      'Začátek události*',
                      _startDateTime,
                      (dateTime) => setState(() => _startDateTime = dateTime),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateTimeField(
                      'Konec události*',
                      _endDateTime,
                      (dateTime) => setState(() => _endDateTime = dateTime),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Participants and pilots
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _maxParticipantsController,
                      decoration: const InputDecoration(
                        labelText: 'Max. účastníků*',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Povinné pole';
                        }
                        final number = int.tryParse(value);
                        if (number == null || number <= 0) {
                          return 'Zadejte platné číslo';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _maxPilotsController,
                      decoration: const InputDecoration(
                        labelText: 'Max. pilotů*',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Povinné pole';
                        }
                        final number = int.tryParse(value);
                        if (number == null || number <= 0) {
                          return 'Zadejte platné číslo';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Create button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveEvent,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Vytvořit událost',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeField(
    String label,
    DateTime dateTime,
    Function(DateTime) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () => _selectDateTime(dateTime, onChanged),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDateTime(DateTime initialDateTime, Function(DateTime) onChanged) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime),
      );

      if (time != null && mounted) {
        final newDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        onChanged(newDateTime);
      }
    }
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement event creation logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vytváření události zatím není implementováno'),
          backgroundColor: Colors.orange,
        ),
      );
      
      // For now, just close the page
      Navigator.of(context).pop();
    }
  }
}
