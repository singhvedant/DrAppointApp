import 'package:dr_appoint_app/modal.dart';
import 'package:dr_appoint_app/problem_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loading_button/loading_button.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _cityName = "";
  static const List<String> _kOptions = <String>[
    'los Angeles',
    'miami',
    'orlando',
    'madison',
    'detroit',
  ];
  @override
  Widget build(BuildContext context) {
    return (_cityName == "")
        ? Scaffold(
            appBar: AppBar(
              title: const Center(child: Text('City Selection')),
            ),
            body: Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 20),
                    const StepIndicator(title: "Select Your city", number: 1),
                    const SizedBox(height: 80),
                    Autocomplete<String>(
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController textEditingController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted) {
                        return TextFormField(
                          controller: textEditingController,
                          decoration: myTextFieldDecoration(
                              topLabel: "Enter city name",
                              hintText: "Type or select from list"),
                          focusNode: focusNode,
                          onFieldSubmitted: (String value) {
                            onFieldSubmitted();
                          },
                        );
                      },
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        return _kOptions.where((String option) {
                          return option
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (String selection) {
                        setState(() {
                          _cityName = selection;
                        });
                      },
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    LoadingButton(
                      // This needs to be async
                      onPressed: () async {
                        await Future.delayed(
                          const Duration(seconds: 3),
                          () => setState(() {
                            _cityName = _kOptions[0];
                          }),
                        );
                      },
                      loadingWidget: const CircularProgressIndicator(),
                      child: const Text('        OR\nUse Location'),
                    ),
                  ],
                ),
              ),
            ),
          )
        : ProblemForm(city: _cityName);
  }
}

InputDecoration myTextFieldDecoration(
    {String topLabel = "",
    String hintText = "",
    double cornerRadius = 5.0,
    Icon? icon}) {
  return InputDecoration(
    labelText: topLabel,
    hintText: hintText,
    icon: icon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
    ),
  );
}
