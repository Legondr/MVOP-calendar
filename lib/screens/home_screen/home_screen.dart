import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  void initState() {
    super.initState();
    fetchAppointments(); // Fetch existing appointments from Firestore
  }

  // Fetch appointments from Firestore
  Future<void> fetchAppointments(
      {DateTime? startDate, DateTime? endDate}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('User is not authenticated.');
      return;
    }

    try {
      debugPrint('Fetching appointments from: $startDate to: $endDate');
      QuerySnapshot querySnapshot;
      if (startDate != null && endDate != null) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('events')
            .where('startTime',
                isGreaterThanOrEqualTo: startDate.toIso8601String())
            .where('endTime', isLessThanOrEqualTo: endDate.toIso8601String())
            .get();
      } else {
        querySnapshot =
            await FirebaseFirestore.instance.collection('events').get();
      }

      setState(() {
        _appointments = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          debugPrint('Fetched event: $data');
          return Appointment(
            subject: data['subject'] ?? '',
            startTime: safeDateParse(data['startTime']) ?? DateTime.now(),
            endTime: safeDateParse(data['endTime']) ?? DateTime.now(),
            isAllDay: data['isAllDay'] ?? false,
            color: Color(data['color'] ?? Colors.blue.value),
          );
        }).toList();
      });
    } catch (e) {
      debugPrint('Error fetching appointments: $e');
    }
  }

  DateTime? safeDateParse(String? dateString) {
    try {
      if (dateString == null) return null;
      return DateTime.parse(dateString);
    } catch (e) {
      debugPrint('Failed to parse date: $dateString, Error: $e');
      return null;
    }
  }

  // Add appointment to Firestore and update local list
  void _addAppointment(Appointment appointment) async {
    try {
      await FirebaseFirestore.instance.collection('events').add({
        'subject': appointment.subject,
        'startTime': appointment.startTime.toIso8601String(),
        'endTime': appointment.endTime.toIso8601String(),
        'isAllDay': appointment.isAllDay,
        'color': appointment.color.value,
      });

      setState(() {
        _appointments.add(appointment);
      });

      debugPrint('Appointment added successfully');
    } catch (e) {
      debugPrint('Failed to add appointment: $e');
    }
  }

  // Sign user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // Drawer menu item builder
  Widget _buildDrawerMenuItem(String title, CalendarView viewType) {
    return ListTile(
      title: Text(title),
      onTap: () {
        setState(() {
          _calendarView = viewType;
        });
        Navigator.pop(context);
      },
    );
  }

  // Show dialog to add an appointment
  void _showAddAppointmentDialog() {
    final TextEditingController subjectController = TextEditingController();
    DateTime? startDateTime = DateTime.now();
    DateTime? endDateTime = DateTime.now();
    bool isAllDay = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('New Appointment'),
              content: SingleChildScrollView(
                child: Column(
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
                          final pickedDate = await showDatePicker(
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
                          final pickedDate = await showDatePicker(
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
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null && context.mounted) {
                            final pickedTime = await showTimePicker(
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
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null && context.mounted) {
                            final pickedTime = await showTimePicker(
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
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (subjectController.text.isNotEmpty &&
                        startDateTime != null &&
                        endDateTime != null) {
                      final newAppointment = Appointment(
                        subject: subjectController.text,
                        startTime: startDateTime!,
                        endTime: endDateTime!,
                        color: Colors.blue,
                        isAllDay: isAllDay,
                      );
                      _addAppointment(newAppointment);
                      Navigator.pop(context);
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
            title: const Text(
              'DMCalendar',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 3, 192, 244),
            actions: [
              IconButton(
                onPressed: signUserOut,
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 3, 192, 244),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Calendar Views',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10), // Space between title and email
                      FutureBuilder<User?>(
                        future: Future.value(FirebaseAuth.instance.currentUser),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ); // Show a loader while fetching user data
                          }
                          if (snapshot.hasData && snapshot.data != null) {
                            return Text(
                              snapshot.data!.email ?? 'No email available',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            );
                          } else {
                            return Text(
                              'No user logged in',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            );
                          }
                        },
                      ),
                    ],
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
            dataSource: MeetingDataSource(_appointments),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddAppointmentDialog,
            backgroundColor: const Color.fromARGB(255, 3, 192, 244),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

// Custom data source for calendar
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
