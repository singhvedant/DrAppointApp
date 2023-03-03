import 'package:dr_appoint_app/appointments.dart';
import 'package:flutter/material.dart';

class ProblemForm extends StatefulWidget {
  const ProblemForm({super.key, required this.city});
  final String city;
  @override
  State<ProblemForm> createState() => _ProblemFormState();
}

class _ProblemFormState extends State<ProblemForm> {
  @override
  Widget build(BuildContext context) {
    final cityName = widget.city;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Problem Form"),
            const SizedBox(width: 40),
            GestureDetector(
              child: const Icon(Icons.edit_calendar),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Appointments())),
            ),
            GestureDetector(
                child: const Icon(Icons.logout),
                onTap: () => print(
                    "SignOutPressed") //TODO: await FirebaseAuth.instance.signOut(),
                ),
          ],
        ),
      ),
      body: Center(
        child: Text(cityName),
      ),
    );
  }
}
