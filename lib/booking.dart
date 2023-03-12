import 'package:dr_appoint_app/modal.dart';
import 'package:dr_appoint_app/payment.dart';
import 'package:flutter/material.dart';

class Booking extends StatefulWidget {
  const Booking({super.key, this.doctor});
  final Doctor? doctor;
  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  @override
  Widget build(BuildContext context) {
    final doc = widget.doctor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
      ),
      body: (doc != null)
          ? Payment(
              doctor: Doctor(doc.drName, "MS"),
            )
          : Container(),
    );
  }
}
