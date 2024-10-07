import 'package:flutter/material.dart';
import 'detailedReport5.dart';
import 'package:krooka/globalVariables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class detailedReport4 extends StatefulWidget {
  const detailedReport4({super.key});

  @override
  _detailedReport4State createState() => _detailedReport4State();
}

class _detailedReport4State extends State<detailedReport4> {
  late int numberOfFields;
  List<TextEditingController> _controllers = [];
  final _formKey = GlobalKey<FormState>();
  List<String> _plates  = [];
  String aId = AuthService.authID!;
  final supabase = Supabase.instance.client;
  String? Mycar;
  late dynamic data;
  bool contextActionPerform = false;

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
    final ScreenHeight = MediaQuery.of(context).size.height;
    final ScreenWidth = MediaQuery.of(context).size.width;
    if (!contextActionPerform) {
      data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      numberOfFields = data['Counter'];
      _controllers = List.generate(numberOfFields, (index) => TextEditingController()); 
      contextActionPerform = true;
    }
    if(Mycar != null){
    _controllers[0].text =Mycar!;
    }
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
                          _plates.add(value);
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Car ${index + 1} Plate Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final uid = await supabase
                    .from("User")
                    .select("IdNumber")
                    .eq("AuthID", aId)
                    .single();
                final response = await supabase
                    .from("Have")
                    .select("ChassisNumber")
                    .eq("IdNumber", uid["IdNumber"]);
                final List chassisNumbers = response.map((item) => item["ChassisNumber"]).toList();
                print (chassisNumbers);
                final carDetails = await Future.wait(
                  chassisNumbers.map((chassisNumber) async {
                    return await supabase
                        .from("Car")
                        .select("Manufacturer, Model, PlateNumber")
                        .eq("ChassisNumber", chassisNumber)
                        .single(); 
                  }).toList(),
                );
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.grey[200],
                      title: Text("Choose One of Your Cars"),
                      content: Container(
                        constraints: BoxConstraints(
                          maxHeight: ScreenHeight *0.5
                        ),
                        child: ListView.builder(
                          
                          shrinkWrap: true,
                          
                          itemCount: carDetails.length,
                          itemBuilder: (context, index) {
                            final car = carDetails[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  Mycar=car['PlateNumber'];
                                });
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 3.0),
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.black26, width: 2),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${car['Manufacturer']} ${car['Model']} ",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenWidth*0.045),
                                    ),
                                    Text("${car['PlateNumber']}"),   
                                  ],
                                ),
                                                        
                              ),
                            );
                            
                          },
                          
                        ),
                      ),
                      actions: [
                        Center(child: ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("cancel")))
                      ],
                    );
                    
                  },
                  
                );
                }
                catch(e){
                  print ('Error retrieving your cars : $e');
                }
              },
              child: Text("Show Cars"),
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
                      Navigator.pushNamed(context, '/DR5', arguments: <String, dynamic>{
                        'Lat' : data['Lat'],
                        'Long' : data['Long'],
                        'Inj' : data['Inj'],
                        'Insurance' : data['Insurance'],
                        'Plates' : _plates
                      });
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
