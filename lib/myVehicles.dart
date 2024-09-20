import 'package:flutter/material.dart';

class MyVehicles extends StatefulWidget {
  const MyVehicles({super.key});


  @override
  State<MyVehicles> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyVehicles> {
  int MyitemCount = 4;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: ListView(
        children: [
          Container(
            height: 170,
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(30)
              
            ),
            child: Row(
              children: [
                Icon(Icons.person_2 , size: 125,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text("Name : " , style: TextStyle(fontSize: 11),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text("Date Of Birth : ",style: TextStyle(fontSize: 11),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text("Phone Number : " ,style: TextStyle(fontSize: 11),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text("Num. Of Accidents : " ,style: TextStyle(fontSize: 11),),
                    ),
                  ],
                ),
                
              ],
            ),
            
          ),

          SizedBox(
            height: 30,
          ),

          // Container(
          //   height: 100,
          //   color: Colors.black,
          // ),
          Container(
            margin: EdgeInsets.all(10),
            height: 350,
            child: Expanded(
              child:ListView.builder(
                itemCount: MyitemCount+1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Container(
                  child: MyitemCount == index ? Center(child:ElevatedButton(onPressed: (){print("Adding a car");}, child: Icon(Icons.add, size: 50, color: Colors.grey,)), ):Text("Car"),
                  width:MediaQuery.sizeOf(context).width*0.8,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(25)
                    
                  ),
            
                ),
                
              ) ),
              
          ),
        ],
      )
    );
  }
}