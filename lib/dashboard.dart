import 'package:dr_appoint_app/problem_form.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _cityName = "";

  static const List<String> _kOptions = <String>[
    'mumbai',
    'chennai',
    'kolkata',
    'delhi',
    'bangalore',
  ];
  @override
  Widget build(BuildContext context) {
    return (_cityName == "")
        ? Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Autocomplete<String>(
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
                        print('You just typed a new entry  $value');
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
