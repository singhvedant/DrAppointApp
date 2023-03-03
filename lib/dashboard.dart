import 'package:flutter/material.dart';
import 'package:flutter_text_box/flutter_text_box.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final key = GlobalKey<FormState>();
  var _citySelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Form(
                key: key,
                child: _citySelected
                    ? const Text('City Selected')
                    : TextBoxIcon(
                        icon: Icons.location_city,
                        inputType: TextInputType.text,
                        label: 'City',
                        hint: 'Please enter your city here',
                        errorText: 'This field is required !',
                        onSaved: (String value) {
                          //TODO: ADD Logic for city selection
                          setState(() {
                            _citySelected = true;
                          });
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          final state = key.currentState;
          if (state!.validate()) {
            state.save();
          }
        },
      ),
    );
  }
}
