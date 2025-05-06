import 'package:flutter/material.dart';
import 'package:smple_app/core/models/event.dart';
import 'package:smple_app/core/services/event_service.dart';

class SimpleCalendar extends StatefulWidget {
  const SimpleCalendar({super.key});

  @override
  State<SimpleCalendar> createState() => _SimpleCalendarState();
}

class _SimpleCalendarState extends State<SimpleCalendar> {
  final  _eventService = EventService();
  final  _title = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addEvent() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Event Title'),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_title.text.isNotEmpty) {
                  final newEvent = Event(
                    id: '', // Firestore will generate the ID
                    title: _title.text,
                    date: _selectedDate,
                  );
                  _eventService.addEvent(newEvent);
                  _title.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Calendar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Events',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<List<Event>>(
                stream: _eventService.getEvents(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  final events = snapshot.data!;
                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return ListTile(
                        title: Text(event.title),
                        subtitle: Text(event.date.toLocal().toString().split(' ')[0]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        tooltip: 'Add Event',
        child: const Icon(Icons.add),
      ),
    );
  }
}
