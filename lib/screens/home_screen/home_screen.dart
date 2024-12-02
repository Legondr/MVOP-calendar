import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Current view of the calendar
  CalendarView _calendarView = CalendarView.month;

  // List of appointments
  List<Appointment> _appointments = [];

  // Sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // Drawer menu items
  Widget _buildDrawerMenuItem(String title, CalendarView viewType) {
    return ListTile(
      title: Text(title),
      onTap: () {
        setState(() {
          _calendarView = viewType; // Update calendar view
        });
        Navigator.pop(context); // Close the drawer
      },
    );
  }

  // Method to add a new appointment
  void _addAppointment(Appointment appointment) {
    setState(() {
      _appointments.add(appointment);
    });
  }

  // Method to show the add appointment dialog
  void _showAddAppointmentDialog() {
    final TextEditingController subjectController = TextEditingController();
    DateTime? startDateTime;
    DateTime? endDateTime;
    bool isAllDay = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('New Appointment'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('All Day'),
                      Switch(
                        value: isAllDay,
                        onChanged: (value) {
                          setDialogState(() {
                            isAllDay = value;
                            startDateTime = null;
                            endDateTime = null;
                          });
                        },
                      ),
                    ],
                  ),
                  if (isAllDay) ...[
                    ListTile(
                      title: Text(
                        startDateTime == null
                            ? 'Select Start Date'
                            : 'Start: ${startDateTime.toString().split(' ')[0]}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setDialogState(() {
                            startDateTime = pickedDate;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text(
                        endDateTime == null
                            ? 'Select End Date'
                            : 'End: ${endDateTime.toString().split(' ')[0]}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setDialogState(() {
                            endDateTime = pickedDate;
                          });
                        }
                      },
                    ),
                  ] else ...[
                    ListTile(
                      title: Text(
                        startDateTime == null
                            ? 'Select Start Time'
                            : 'Start: ${startDateTime.toString()}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setDialogState(() {
                              startDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        }
                      },
                    ),
                    ListTile(
                      title: Text(
                        endDateTime == null
                            ? 'Select End Time'
                            : 'End: ${endDateTime.toString()}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setDialogState(() {
                              endDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        }
                      },
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (subjectController.text.isNotEmpty &&
                        (isAllDay ||
                            (startDateTime != null && endDateTime != null))) {
                      final newAppointment = Appointment(
                        startTime: isAllDay
                            ? startDateTime ?? DateTime.now()
                            : startDateTime!,
                        endTime: isAllDay
                            ? endDateTime ?? startDateTime ?? DateTime.now()
                            : endDateTime!,
                        subject: subjectController.text,
                        color: Colors.blue,
                        isAllDay: isAllDay,
                      );
                      _addAppointment(newAppointment);
                      Navigator.pop(context); // Close dialog
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('No user logged in.'));
        }

        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'DMCalendar',
                  style: TextStyle(color: Colors.white),
                ),
                if (snapshot.hasData && snapshot.data!.email != null)
                  Text(
                    snapshot.data!.email!,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
              ],
            ),
            backgroundColor: const Color.fromARGB(255, 3, 192, 244),
            actions: [
              IconButton(
                onPressed: signUserOut,
                icon: const Icon(Icons.logout),
              )
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 3, 192, 244),
                  ),
                  child: Center(
                    child: Text(
                      'Calendar Views',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                _buildDrawerMenuItem('Month', CalendarView.month),
                _buildDrawerMenuItem('Week', CalendarView.week),
                _buildDrawerMenuItem('Day', CalendarView.day),
                _buildDrawerMenuItem('Schedule', CalendarView.schedule),
                _buildDrawerMenuItem(
                    'Timeline Week', CalendarView.timelineWeek),
              ],
            ),
          ),
          body: SfCalendar(
            view: _calendarView,
            firstDayOfWeek: 1,
            dataSource: MeetingDataSource(_appointments),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddAppointmentDialog,
            child: const Icon(Icons.add),
            backgroundColor: const Color.fromARGB(255, 3, 192, 244),
          ),
        );
      },
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
