import 'package:dr_appoint_app/modal.dart';
import 'package:flutter/material.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  List<Appointment> appointments = [];

  @override
  void initState() {
    Database().getUserAppointments().then((value) => {
          setState(
            () => appointments = value,
          )
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointments"),
      ),
      body: ListView.builder(
        itemBuilder: _itemBuilder,
        itemCount: appointments.length,
      ),
    );
  }

  Widget? _itemBuilder(BuildContext context, int i) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Text(
              "${appointments[i].doctor.drName}\n${appointments[i].appointmentTime}\n",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
