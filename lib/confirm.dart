import 'package:dr_appoint_app/modal.dart';
import 'package:flutter/material.dart';

class Confirm extends StatefulWidget {
  const Confirm(this.appointment, {super.key});
  final Appointment appointment;
  @override
  State<Confirm> createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  @override
  Widget build(BuildContext context) {
    var appointment = widget.appointment;
    return Center(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Your Appointment is booked.",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Text(appointment.doctor.drName),
              Text(appointment.doctor.spec),
              Text(appointment.appointmentTime),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/appointment");
                      },
                      child: const Text("View Appointments")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Search for more doctors")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
