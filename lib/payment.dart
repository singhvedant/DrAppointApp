import 'dart:io';

import 'package:checkout_screen_ui/checkout_page.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dr_appoint_app/appointments.dart';
import 'package:dr_appoint_app/modal.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  const Payment({super.key, required this.doctor});
  final Doctor doctor;
  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final GlobalKey<CardPayButtonState> _payBtnKey =
      GlobalKey<CardPayButtonState>();
  var _done = false;

  @override
  Widget build(BuildContext context) {
    var doctor = widget.doctor;
    final List<PriceItem> priceItems = [
      PriceItem(
          name: "${doctor.drName} Scheduling Charges",
          quantity: 1,
          totalPriceCents: 5200),
      PriceItem(name: 'Booking Charge', quantity: 1, totalPriceCents: 2499),
      PriceItem(name: 'Service Charge', quantity: 1, totalPriceCents: 8599),
    ];
    return (_done)
        ? const Text('Success')
        : CheckoutPage(
            priceItems: priceItems,
            payToName: "Username", //TODO: Replace with Firebase.username
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

  confirmBooking() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      text: "Your transaction was successful!",
      onConfirmBtnTap: () {
        Navigator.pop(context);
      },
    );
  }
}