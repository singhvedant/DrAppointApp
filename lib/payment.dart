import 'dart:io';

import 'package:checkout_screen_ui/checkout_page.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dr_appoint_app/confirm.dart';
import 'package:dr_appoint_app/modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  const Payment({super.key, required this.appointment});
  final Appointment appointment;

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  var user = FirebaseAuth.instance.currentUser!.displayName ?? "";

  final GlobalKey<CardPayButtonState> _payBtnKey =
      GlobalKey<CardPayButtonState>();
  late Appointment? _done;
  @override
  Widget build(BuildContext context) {
    var doctor = widget.appointment.doctor;
    final List<PriceItem> priceItems = [
      PriceItem(
          name: "${doctor.drName} Scheduling Charges",
          quantity: 1,
          totalPriceCents: 5200),
      PriceItem(name: 'Booking Charge', quantity: 1, totalPriceCents: 2499),
      PriceItem(name: 'Service Charge', quantity: 1, totalPriceCents: 8599),
    ];
    return (_done != null)
        ? Confirm(_done!)
        : CheckoutPage(
            priceItems: priceItems,
            payToName: user,
            displayNativePay: true,
            onNativePay: () => _nativePayClicked(context),
            displayCashPay: true,
            onCashPay: () => _cashPayClicked(context),
            isApple: Platform.isIOS,
            onCardPay: (results) => _creditPayClicked(results),
            payBtnKey: _payBtnKey,
            displayTestData: true,
          );
  }

  _nativePayClicked(BuildContext context) {
    confirmBooking();
  }

  _cashPayClicked(BuildContext context) {
    confirmBooking();
  }

  _creditPayClicked(CardFormResults results) {
    confirmBooking();
  }

  confirmBooking() async {
    var appointment = widget.appointment;
    await Database().setDoctorAppointment(appointment).then((value) {
      Database().setUserAppointment(appointment);
      if (value) {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "Your transaction was successful!",
          onConfirmBtnTap: () {
            setState(() {
              _done = widget.appointment;
            });
          },
        );
      } else {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "Unable to book your appointment!",
          onConfirmBtnTap: () {},
        );
      }
    }).timeout(const Duration(seconds: 10));
  }
}
