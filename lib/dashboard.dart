import 'package:dr_appoint_app/problem_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_box/flutter_text_box.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final key = GlobalKey<FormState>();
  var _cityName = "";

  @override
  Widget build(BuildContext context) {
    return (_cityName == "")
        ? Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Form(
                  key: key,
                  child: TextBoxIcon(
                    icon: Icons.location_city,
                    inputType: TextInputType.text,
                    label: 'City',
                    hint: 'Please enter your city here',
                    errorText: 'This field is required !',
                    onSaved: (String value) {
                      //TODO: ADD Logic for city selection
                      setState(() {
                        _cityName = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            floatingActionButton: (_cityName != "")
                ? null
                : FloatingActionButton(
                    child: const Icon(Icons.check),
                    onPressed: () {
                      final state = key.currentState;
                      if (state!.validate()) {
                        state.save();
                      }
                    },
                  ),
          )
        : ProblemForm(city: _cityName);
  }
}
