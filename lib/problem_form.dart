import 'package:dr_appoint_app/appointments.dart';
import 'package:dr_appoint_app/booking.dart';
import 'package:dr_appoint_app/dashboard.dart';
import 'package:dr_appoint_app/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_box/flutter_text_box.dart';

class ProblemForm extends StatefulWidget {
  const ProblemForm({super.key, required this.city});
  final String city;
  @override
  State<ProblemForm> createState() => _ProblemFormState();
}

class _ProblemFormState extends State<ProblemForm> {
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
  List<Doctor> doctors = [
    Doctor("Dr. Manoj Sharma", "General physician"),
    Doctor("Dr. Ranjana Srivastava", "Gynecologist"),
    Doctor("Dr. Akhil Verma", "Orthopedic"),
    Doctor("Dr. Kamala Rathi", "Orthopedic"),
  ]; //TODO: Change with list from server
  @override
  Widget build(BuildContext context) {
    final cityName = widget.city;
    final constTop = [
      const SizedBox(height: 32),
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
                  topLabel: "Problem", hintText: "Select your problem"),
              focusNode: focusNode,
              onFieldSubmitted: (String value) {
                onFieldSubmitted();
                print('You just typed a new entry  $value');
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

    for (var docs in doctors) {
      constTop.add(doctorCard(docs));
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
                onTap: () => print(
                    "SignOutPressed") //TODO: await FirebaseAuth.instance.signOut(),
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
