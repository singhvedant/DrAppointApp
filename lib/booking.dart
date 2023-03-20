import 'dart:async';

import 'package:dr_appoint_app/modal.dart';
import 'package:dr_appoint_app/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_loading_button/loading_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Booking extends StatefulWidget {
  const Booking({super.key, required this.doctor, required this.selected});
  final Doctor doctor;
  final bool selected;
  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final loadingText = [
    "Searching for doctors near you",
    "Filtering based on location",
    "Finding experts for your particular problem",
    "Filtering according to ratings",
    "Found perfect mach for your problem",
    "Finishing up!",
  ];
  var sec = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var selected = widget.selected;
    if (!selected) {
      Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        setState(() {
          sec += 1;
        });
        if (sec > 5) {
          timer.cancel();
          sec = 6;
        }
      });
    } else {
      sec = 6;
    }
  }

  var datetime = 'Schedule time for appointment';
  var appointment;
  @override
  Widget build(BuildContext context) {
    final doc = widget.doctor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
      ),
      body: (sec == 7)
          ? Payment(appointment: appointment)
          : (sec == 6)
              ? Center(
                  //TODO: Make this widget
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 24),
                          Text(doc.drName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(doc.spec,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                fontSize: 18,
                              )),
                          const SizedBox(height: 24),
                          TextButton(
                              onPressed: () {
                                DatePicker.showPicker(context,
                                    showTitleActions: true,
                                    pickerModel: CustomPicker(),
                                    onChanged: (date) {
                                  setState(() {
                                    datetime =
                                        "${givemonth(date.month)} ${date.day}, ${date.hour > 12 ? date.hour - 12 : date.hour} ${date.hour > 12 ? "PM" : "AM"}";
                                  });
                                }, onConfirm: (date) {
                                  setState(() {
                                    datetime =
                                        "${givemonth(date.month)} ${date.day}, ${date.hour > 12 ? date.hour - 12 : date.hour} ${date.hour > 12 ? "PM" : "AM"}";
                                  });
                                }, locale: LocaleType.en);
                              },
                              child: Text(
                                datetime,
                                style: const TextStyle(
                                    color: Colors.blue, fontSize: 15),
                              )),
                          LoadingButton(
                            // This needs to be async
                            onPressed: () async {
                              if (datetime != 'Schedule time for appointment') {
                                appointment = Appointment(doc, datetime);
                                await Database()
                                    .checkDrBusy(appointment)
                                    .then((value) {
                                  if (value == true) {
                                    setState(() {
                                      sec += 1;
                                    });
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Please schedule another time\nThe Doctor is busy at this hour.",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                });
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please select appointment time",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                            loadingWidget: const CircularProgressIndicator(),
                            child: const Text('Check'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.blue,
                        size: 150,
                      ),
                      Text(loadingText[sec]),
                    ],
                  ),
                ),
    );
  }
}

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime? currentTime, LocaleType? locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    setLeftIndex(this.currentTime.month);
    setMiddleIndex(this.currentTime.day);
    setRightIndex(9);
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index > 0 && index < 13) {
      return givemonth(index);
    }
    return null;
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index > 0 && index < 32) {
      return digits(index, 2);
    }
    return null;
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 9 && index < 17) {
      return (index <= 12) ? "$index AM" : "${index - 12} PM";
    }
    return null;
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [2, 1, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentLeftIndex(),
            currentMiddleIndex(),
            currentRightIndex(),
          )
        : DateTime(
            currentTime.year,
            currentLeftIndex(),
            currentMiddleIndex(),
            currentRightIndex(),
          );
  }
}

String? givemonth(i) {
  switch (i) {
    case 1:
      return "January";
    case 2:
      return "February";
    case 3:
      return "March";
    case 4:
      return "April";
    case 5:
      return "May";
    case 6:
      return "June";
    case 7:
      return "July";
    case 8:
      return "August";
    case 9:
      return "September";
    case 10:
      return "October";
    case 11:
      return "November";
    case 12:
      return "December";

    default:
      return null;
  }
}
