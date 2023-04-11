import 'package:dr_appoint_app/appointments.dart';
import 'package:dr_appoint_app/booking.dart';
import 'package:dr_appoint_app/dashboard.dart';
import 'package:dr_appoint_app/modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProblemForm extends StatefulWidget {
  const ProblemForm({super.key, required this.city});
  final String city;
  @override
  State<ProblemForm> createState() => _ProblemFormState();
}

class _ProblemFormState extends State<ProblemForm> {
  List<Doctor> doctors = [];
  static const List<String> _kOptions = <String>[
    'fever',
    'sickness',
    'depression',
    'pregnancy',
    'stomachache',
    'headache',
    'red eye',
    'viral',
    'covid-19',
    'diarrhea',
  ];

  @override
  void initState() {
    final cityName = widget.city;
    Database().getDoctorsInCity(cityName).then((value) => {
          setState(
            () => doctors = value,
          )
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cityName = widget.city;

    final constTop = [
      const SizedBox(height: 32),
      const Padding(
        padding: EdgeInsets.all(16.0),
        child: StepIndicator(title: "Doctor Selections", number: 2),
      ),
      Padding(
        padding: const EdgeInsets.all(16),
        child: Autocomplete<String>(
          fieldViewBuilder: (BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            return TextFormField(
              controller: textEditingController,
              decoration: myTextFieldDecoration(
                  topLabel: "Get Recommendation for disease",
                  hintText: "Select your problem"),
              focusNode: focusNode,
              onFieldSubmitted: (String value) {
                onFieldSubmitted();
              },
            );
          },
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return _kOptions.where((String option) {
              return option.contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) =>
              bookDoctor(context, doctor: doctors[0], selected: false),
        ),
      ),
      const Divider(
        height: 20,
        color: Colors.black,
      ),
      const Center(
        child: Text('OR'),
      ),
      const Divider(
        height: 20,
        color: Colors.black,
      ),
      const SizedBox(height: 16),
      Title(
        color: Colors.blue,
        child: Text(
          "Doctors in $cityName",
          textScaleFactor: 2,
        ),
      ),
      const SizedBox(height: 16),
    ];
    if (doctors.isEmpty) {
      constTop.add(const Text('No Doctors Available in your city.'));
    } else {
      for (var docs in doctors) {
        constTop.add(doctorCard(docs));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Book a Consult"),
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
              onTap: () async => await FirebaseAuth.instance.signOut(),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: constTop,
        ),
      ),
    );
  }

  doctorCard(Doctor doc) {
    return GestureDetector(
      onTap: () => bookDoctor(context, doctor: doc, selected: true),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(8),
        child: ListTile(
          title: Text(doc.drName),
          trailing: Text(doc.spec),
        ),
      ),
    );
  }

  bookDoctor(BuildContext context,
      {required Doctor doctor, required bool selected}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => Booking(
              doctor: doctor,
              selected: selected,
            )),
      ),
    );
  }
}
