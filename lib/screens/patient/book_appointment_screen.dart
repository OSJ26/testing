import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class BookAppointmentScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;

  const BookAppointmentScreen({super.key, required this.doctorId, required this.doctorName});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime? selectedDate;
  String? selectedTimeSlot;
  bool isLoading = false;

  final List<String> timeSlots = [
    "09:00 AM", "09:30 AM", "10:00 AM", "10:30 AM",
    "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM",
    "01:00 PM", "01:30 PM", "02:00 PM", "02:30 PM",
    "03:00 PM", "03:30 PM", "04:00 PM", "04:30 PM",
  ];

  void _submitBooking() async {
    if (selectedDate == null || selectedTimeSlot == null) return;

    setState(() => isLoading = true);

    final response = await ApiServices.bookAppointment(
      doctorId: widget.doctorId,
      date: DateFormat('yyyy-MM-dd').format(selectedDate!),
      timeSlot: selectedTimeSlot!, patientId: '',
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Appointment Booked Successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Appointment booking issue" ?? 'Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Appointment with ${widget.doctorName}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Select Date:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(selectedDate == null
                  ? "Choose Date"
                  : DateFormat('EEE, dd MMM yyyy').format(selectedDate!)),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
            ),
            const SizedBox(height: 20),
            const Text("Select Time Slot:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: timeSlots.map((slot) {
                final isSelected = selectedTimeSlot == slot;
                return ChoiceChip(
                  label: Text(slot),
                  selected: isSelected,
                  onSelected: (_) => setState(() => selectedTimeSlot = slot),
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: isLoading ? null : _submitBooking,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Confirm Appointment"),
            )
          ],
        ),
      ),
    );
  }
}
