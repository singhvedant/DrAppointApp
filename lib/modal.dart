import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class Appointment {
  var appointmentID = DateTime.now().toString();
  final Doctor doctor;
  final String appointmentTime;

  Appointment(this.doctor, this.appointmentTime) {
    appointmentID =
        appointmentID.substring(1, 19) + appointmentID.substring(20, 25);
  }
}

class Doctor {
  final String doctorID;
  final String drName;
  final String spec;

  Doctor(this.doctorID, this.drName, this.spec);
}

class Database {
  final database = FirebaseDatabase.instance;

  getRootReference(String path) {
    return database.ref(path);
  }

  Future<bool> setDoctorAppointment(Appointment appointment) async {
    var user = FirebaseAuth.instance.currentUser!.displayName ?? "Anonymous";
    final reference = getRootReference(
        '/DoctorAppointments/${appointment.doctor.doctorID} ${appointment.doctor.drName}');
    try {
      await reference.push().update({
        'clientName': 'Bala Akhil',
        'timeSlot': appointment.appointmentTime,
      });
    } catch (e) {
      return false;
    }
    return setDoctorBusyTime(appointment);
  }

  Future<bool> setDoctorBusyTime(Appointment appointment) async {
    final reference = getRootReference('/drBusy/');
    try {
      await reference.update({
        "${appointment.doctor.doctorID} ${appointment.doctor.drName}":
            appointment.appointmentTime,
      });
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> setUserAppointment(Appointment appointment) async {
    var user = FirebaseAuth.instance.currentUser!.uid;
    final reference = getRootReference('/UserAppointments/$user');
    try {
      await reference.push().update({
        'doctorName': appointment.doctor.drName,
        'timeSlot': appointment.appointmentTime,
      });
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<List<Doctor>> getDoctorsInCity(String cityName) async {
    var ref = getRootReference("/doctorsInCity");
    List<Doctor> doctors = [];
    final snapshot = await ref.child(cityName).get();
    if (snapshot.exists) {
      var doctorList = snapshot.value;
      for (var docs in doctorList.keys) {
        Doctor doc = Doctor(
          docs.toString(),
          doctorList[docs]['name'].toString(),
          doctorList[docs]['spec'].toString(),
        );

        doctors.add(doc);
      }
    }

    return doctors;
  }

  Future<List<Appointment>> getUserAppointments() async {
    var user = FirebaseAuth.instance.currentUser!.uid;
    var ref = getRootReference("/UserAppointments");
    List<Appointment> appointments = [];
    final snapshot = await ref.child(user).get();
    if (snapshot.exists) {
      var appointmentList = snapshot.value;
      for (var apps in appointmentList.keys) {
        Appointment app = Appointment(
            Doctor(
              "",
              appointmentList[apps]['doctorName'].toString(),
              "",
            ),
            appointmentList[apps]['timeSlot'].toString());

        appointments.add(app);
      }
    }

    return appointments;
  }

  Future<bool> checkDrBusy(Appointment appointment) async {
    var ref = getRootReference("/drBusy");
    final snapshot = await ref
        .child("${appointment.doctor.doctorID} ${appointment.doctor.drName}")
        .get();
    if (snapshot.exists) {
      if (snapshot.value == appointment.appointmentTime) {
        return false;
      }
    }
    return true;
  }
}

class StepIndicator extends StatefulWidget {
  const StepIndicator({super.key, required this.title, required this.number});
  final String title;
  final int number;
  @override
  State<StepIndicator> createState() => _StepIndicatorState();
}

class _StepIndicatorState extends State<StepIndicator> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(widget.title),
        const SizedBox(height: 10),
        StepProgressIndicator(
          totalSteps: 3,
          currentStep: widget.number,
          selectedColor: Colors.blue,
          unselectedColor: Colors.grey,
        ),
      ],
    );
  }
}
