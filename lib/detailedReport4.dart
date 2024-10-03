import 'package:flutter/material.dart';
import 'detailedReport5.dart';

class detailedReport4 extends StatefulWidget {
  const detailedReport4({super.key});

  @override
  _detailedReport4State createState() => _detailedReport4State();
}

class _detailedReport4State extends State<detailedReport4> {
  late int numberOfFields;
  List<TextEditingController> _controllers = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    // Dispose all text controllers when the widget is destroyed
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    numberOfFields = data['Counter'];
    _controllers = List.generate(numberOfFields, (index) => TextEditingController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Detailed Report 4'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the plate numbers for the cars:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Expanded(
                child: ListView.builder(
                  itemCount: numberOfFields,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        controller: _controllers[index],
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter the car plate number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Car ${index + 1} Plate Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to DetailedReport3
                  },
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => detailedReport5()),
                      );
                    }
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
