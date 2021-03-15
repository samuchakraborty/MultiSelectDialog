import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_upload/model.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DemoPage(),
  ));
}

// fetchData() async {
// //  var fullUrl = "http://139.59.112.145/api/registration/helper/hospital/";
//
//   final response = await http.get(
//     Uri(
//         scheme: "http",
//         host: "139.59.112.145",
//         path: "/api/registration/helper/hospital/"),
//   );
//
//   final jsonResponse = json.decode(response.body);
//   Helper helper = new Helper.fromJson(jsonResponse);
//   List<Service> services = [];
//   for (var i = 0; i < helper.data.services.length; i++) {
//     //print(helper.data.services[i].name);
//     services.add(helper.data.services[i]);
//   }
//
//   return services;
// }

/// A demo page that displays an [ElevatedButton]
class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  List<String> data = [];
  String user, user2, user1;
  @override
  void initState() {
    super.initState();

  }

  fetchDivisons() async {
    final response = await http.get(
      Uri(
          scheme: "http",
          host: "139.59.112.145",
          path: "/api/registration/helper/hospital/"),
    );
    final jsonResponse = json.decode(response.body);
    Helper helper = new Helper.fromJson(jsonResponse);
    for (var i = 0; i < helper.data.surguries.length; i++) {
      //  data.add(helper.data.surguries[i].name);
    }
    // print(data);
    return helper;
  }

  @override
  Widget build(BuildContext context) {
    /// Stores the selected flavours
    final _formKey = GlobalKey<FormState>();
    List<String> flavours = [];
    List<String> flavours1 = [];
    List<String> flavours2 = [];
    //  fetchData();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FutureBuilder(
              future: fetchDivisons(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return CupertinoActivityIndicator();
                } else {
                  for (var i = 0; i < snapshot.data.data.services.length; i++) {
                    user = snapshot.data.data.services[i].name;
                  }
                  for (var i = 0;
                      i < snapshot.data.data.surguries.length;
                      i++) {
                    user1 = snapshot.data.data.surguries[i].name;
                  }
                  for (var i = 0;
                      i < snapshot.data.data.testFacilities.length;
                      i++) {
                    user2 = snapshot.data.data.testFacilities[i].name;
                  }

                  return Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("services"),
                          Container(
                            width: 100,
                            child: ElevatedButton(
                                child: Text('services'),
                                onPressed: () async {
                                  flavours = await showDialog<List<String>>(
                                          context: context,
                                          builder: (_) => MultiSelectDialog(
                                                question: Text(
                                                    'Select Your services'),
                                                answers: [user],

                                                // [
                                                //
                                                //   // 'Chocolate',
                                                //   // 'Caramel',
                                                //   // 'Vanilla',
                                                //   // 'Peanut Butter',
                                                //   // 'samy',
                                                //   // "you",
                                                //   // "gieo",
                                                //   // "hello",
                                                //   'love you'
                                                // ]
                                              )) ??
                                      [];
                                  print(flavours);
                                  // Logic to save selected flavours in the database
                                }),
                          ),
                        ],
                      ),
                      Row(
                        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("surguries"),
                          Container(
                            child: Form(
                              key: _formKey,
                              child: MultiSelectFormField(
                                context: context,
                                buttonText: 'surguries',
                                itemList: [
                                  user2,
                                  'Chocolate',
                                  'Caramel',
                                  'Vanilla',
                                  'Peanut Butter'
                                ],
                                questionText: 'Select Your surguries',
                                validator: (flavours) => flavours.length == 0
                                    ? 'Please select at least one flavor!'
                                    : null,
                                onSaved: (flavours) {
                                  print(flavours);
                                  // Logic to save selected flavours in the database
                                },
                              ),
                              onChanged: () {
                                if (_formKey.currentState.validate()) {
                                  // Invokes the OnSaved Method
                                  _formKey.currentState.save();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("testFacilities"),
                          Container(
                            width: 100,
                            child: ElevatedButton(
                                child: Text('testFacilities'),
                                onPressed: () async {
                                  flavours2 = await showDialog<List<String>>(
                                          context: context,
                                          builder: (_) => MultiSelectDialog2(
                                                question: Text(
                                                    'Select Your testFacilities'),
                                                answers: [
                                                  user2,
                                                  'samy',
                                                  "you",
                                                  "gieo",
                                                  "hello",
                                                ],

                                                // [
                                                //
                                                //   // 'Chocolate',
                                                //   // 'Caramel',
                                                //   // 'Vanilla',
                                                //   // 'Peanut Butter',
                                                //   // 'samy',
                                                //   // "you",
                                                //   // "gieo",
                                                //   // "hello",
                                                //   'love you'
                                                // ]
                                              )) ??
                                      [];
                                  print(flavours2);
                                  // Logic to save selected flavours in the database
                                }),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              }),
        ],
      ),
    );
  }
}

/// A Custom Dialog that displays a single question & list of answers.
class MultiSelectDialog extends StatelessWidget {
  /// List to display the answer.
  final List<String> answers;

  /// Widget to display the question.
  final Widget question;

  /// List to hold the selected answer
  /// i.e. ['a'] or ['a','b'] or ['a','b','c'] etc.
  final List<String> selectedItems = [];

  /// Map that holds selected option with a boolean value
  /// i.e. { 'a' : false}.
  static Map<String, bool> mappedItem;

  MultiSelectDialog({this.answers, this.question});

  /// Function that converts the list answer to a map.
  Map<String, bool> initMap() {
    return mappedItem = Map.fromIterable(answers,
        key: (k) => k.toString(),
        value: (v) {
          if (v != true && v != false)
            return false;
          else
            return v as bool;
        });
  }

  @override
  Widget build(BuildContext context) {
    if (mappedItem == null) {
      initMap();
    }
    return SimpleDialog(
      title: question,
      children: [
        ...mappedItem.keys.map((String key) {
          return StatefulBuilder(
            builder: (_, StateSetter setState) => CheckboxListTile(
                title: Text(key), // Displays the option
                value: mappedItem[key], // Displays checked or unchecked value
                controlAffinity: ListTileControlAffinity.platform,
                onChanged: (value) => setState(() => mappedItem[key] = value)),
          );
        }).toList(),
        Align(
            alignment: Alignment.center,
            child: ElevatedButton(
                style: ButtonStyle(visualDensity: VisualDensity.comfortable),
                child: Text('Submit'),
                onPressed: () {
                  // Clear the list

                  selectedItems.clear();

                  // Traverse each map entry
                  mappedItem.forEach((key, value) {
                    if (value == true) {
                      selectedItems.add(key);
                    }
                  });

                  // Close the Dialog & return selectedItems
                  Navigator.pop(context, selectedItems);
                }))
      ],
    );
  }
}

class MultiSelectDialog2 extends StatelessWidget {
  /// List to display the answer.
  final List<String> answers;

  /// Widget to display the question.
  final Widget question;

  /// List to hold the selected answer
  /// i.e. ['a'] or ['a','b'] or ['a','b','c'] etc.
  final List<String> selectedItems = [];

  /// Map that holds selected option with a boolean value
  /// i.e. { 'a' : false}.
  static Map<String, bool> mappedItem;

  MultiSelectDialog2({this.answers, this.question});

  /// Function that converts the list answer to a map.
  Map<String, bool> initMap() {
    return mappedItem = Map.fromIterable(answers,
        key: (k) => k.toString(),
        value: (v) {
          if (v != true && v != false)
            return false;
          else
            return v as bool;
        });
  }

  @override
  Widget build(BuildContext context) {
    if (mappedItem == null) {
      initMap();
    }
    return SimpleDialog(
      title: question,
      children: [
        ...mappedItem.keys.map((String key) {
          return StatefulBuilder(
            builder: (_, StateSetter setState) => CheckboxListTile(
                title: Text(key), // Displays the option
                value: mappedItem[key], // Displays checked or unchecked value
                controlAffinity: ListTileControlAffinity.platform,
                onChanged: (value) => setState(() => mappedItem[key] = value)),
          );
        }).toList(),
        Align(
            alignment: Alignment.center,
            child: ElevatedButton(
                style: ButtonStyle(visualDensity: VisualDensity.comfortable),
                child: Text('Submit'),
                onPressed: () {
                  // Clear the list

                  selectedItems.clear();

                  // Traverse each map entry
                  mappedItem.forEach((key, value) {
                    if (value == true) {
                      selectedItems.add(key);
                    }
                  });

                  // Close the Dialog & return selectedItems
                  Navigator.pop(context, selectedItems);
                }))
      ],
    );
  }
}

class MultiSelectFormField extends FormField<List<String>> {
  /// Holds the items to display on the dialog.
  final List<String> itemList;

  /// Enter text to show on the button.
  final String buttonText;

  /// Enter text to show question on the dialog
  final String questionText;

  // Constructor
  MultiSelectFormField({
    this.buttonText,
    this.questionText,
    this.itemList,
    BuildContext context,
    FormFieldSetter<List<String>> onSaved,
    FormFieldValidator<List<String>> validator,
    List<String> initialValue,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue ?? [], // Avoid Null
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState<List<String>> state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                        child: Card(
                            elevation: 3,
                            child: ClipPath(
                                child: Container(
                                  height: 50,
                                  width: 200,
                                  color: Colors.blue,
                                  child: Center(
                                    //If value is null or no option is selected
                                    child: (state.value == null ||
                                            state.value.length <= 0)

                                        // Show the buttonText as it is
                                        ? Text(
                                            buttonText,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )

                                        // Else show number of selected options
                                        : Text(
                                            state.value.length == 1
                                                // SINGLE FLAVOR SELECTED
                                                ? '${state.value.length.toString()} '
                                                    ' ${buttonText.substring(0, buttonText.length - 1)} SELECTED '
                                                // MULTIPLE FLAVOR SELECTED
                                                : '${state.value.length.toString()} '
                                                    ' $buttonText SELECTED',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ),
                                clipper: ShapeBorderClipper(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3))))),
                        onTap: () async => state.didChange(await showDialog(
                                context: context,
                                builder: (_) => MultiSelectDialog(
                                      question: Text(questionText),
                                      answers: itemList,
                                    )) ??
                            []))
                  ],
                ),
                // If validation fails, display an error
                state.hasError
                    ? Center(
                        child: Text(
                          state.errorText,
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Container() //Else show an empty container
              ],
            );
          },
        );
}
