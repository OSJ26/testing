import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testing/services/api_service.dart';

Future<void> showRescheduleDialog(BuildContext context, String appointmentId) async {
  String? selectedSlot;
  final List<String> slots = [
    "09:00 AM", "09:30 AM", "10:00 AM", "10:30 AM",
    "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM",
    "01:00 PM", "01:30 PM", "02:00 PM", "02:30 PM",
    "03:00 PM", "03:30 PM", "04:00 PM", "04:30 PM",
  ];

  DateTime? newDate;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Reschedule Appointment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_month),
                label: Text(newDate == null ? "Choose Date" : DateFormat('EEE, dd MMM').format(newDate!)),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (picked != null) setState(() => newDate = picked);
                },
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 10,
                children: slots.map((slot) {
                  return ChoiceChip(
                    label: Text(slot),
                    selected: selectedSlot == slot,
                    onSelected: (_) => setState(() => selectedSlot = slot),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (newDate == null || selectedSlot == null) return;
                  final response = await ApiServices.rescheduleAppointment(
                    appointmentId,
                    DateFormat('yyyy-MM-dd').format(newDate!),
                    selectedSlot!,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Reschedule Done")),
                  );
                },
                child: const Text("Reschedule"),
              )
            ],
          ),
        ),
      );
    },
  );
}
