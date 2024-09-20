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
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: ListView(
        children: [
          Container(
            height: ScreenHeight*0.2,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(30)
              
            ),
            child: Row(
              children: [
                Icon(Icons.person_2 , size: ScreenWidth*0.32,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text("Name : " , style: TextStyle(fontSize: ScreenWidth*0.03),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text("Date Of Birth : ",style: TextStyle(fontSize: ScreenWidth*0.03),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text("Phone Number : " ,style: TextStyle(fontSize: ScreenWidth*0.03),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text("Num. Of Accidents : " ,style: TextStyle(fontSize: ScreenWidth*0.03),),
                    ),
                  ],
                ),
                
              ],
            ),
            
          ),

          Container(
            margin: EdgeInsets.only(left: 30, top: 15),
            child: Text("My Cars ", style: TextStyle(fontSize: ScreenWidth*0.05 , fontWeight: FontWeight.bold),),
          ),

     
          Container(
            margin: EdgeInsets.all(10),
            height: ScreenHeight *0.6,
            child: Expanded(
              child:ListView.builder(
                itemCount: MyitemCount+1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Container(
                  child: MyitemCount == index ? GestureDetector(
                    onTap: (){
                      print("Adding a car");
                    },
                    child: Container(
                       width:MediaQuery.sizeOf(context).width*0.8,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                          color: Colors.grey[350],
                          borderRadius: BorderRadius.circular(25),
                          ),
                      child: Center(
                         
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Add a Car", style: TextStyle(fontSize: 20 , color: Colors.grey[500]),),
                              SizedBox(height: 30,),
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[600]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Icon(Icons.add ,size: 45,color: Colors.grey[600],)),
                              SizedBox(height: 50,)
                            ],
                          )
                        ),
                            
                          ),
                  )
                        :
                        Container(
                          padding:EdgeInsets.all(10),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(child: Text("Car ${index+1}" , style: TextStyle(fontSize: ScreenWidth*0.05 , fontWeight: FontWeight.bold),)),
                              SizedBox(height: ScreenHeight*0.01,),
                              Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Row(
                                  children: [
                                    Text("Car Manufacturer : ", style: TextStyle(fontWeight: FontWeight.bold ,fontSize: ScreenWidth*0.035, )),
                                    Text("Toyota", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white , fontSize: ScreenWidth*0.04),)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Row(
                                  children: [
                                    Text("Car Model : ", style: TextStyle(fontWeight: FontWeight.bold ,fontSize: ScreenWidth*0.035, )),
                                    Text("Camry", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white , fontSize: ScreenWidth*0.04),)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Row(
                                  children: [
                                    Text("Year : ", style: TextStyle(fontWeight: FontWeight.bold ,fontSize: ScreenWidth*0.035, )),
                                    Text("2021", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white , fontSize: ScreenWidth*0.04),)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Row(
                                  children: [
                                    Text("Car Color : ", style: TextStyle(fontWeight: FontWeight.bold ,fontSize: ScreenWidth*0.035, )),
                                    Text("White", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white , fontSize: ScreenWidth*0.04),)
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Row(
                                  children: [
                                    Text("Plate Number : ", style: TextStyle(fontWeight: FontWeight.bold ,fontSize: ScreenWidth*0.035, )),
                                    Text("33-246785", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white , fontSize: ScreenWidth*0.04),)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Row(
                                  children: [
                                    Text("Car Owner : ", style: TextStyle(fontWeight: FontWeight.bold ,fontSize: ScreenWidth*0.035, )),
                                    Text("Rami Saed", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white , fontSize: ScreenWidth*0.04),)
                                  ],
                                ),
                              ),
                             
                              
                              
                              Center(child: Padding(
                                padding: const EdgeInsets.only(top: 17.0),
                                child: ElevatedButton(onPressed: (){}, child: Text("View history" , style: TextStyle(color: Colors.black,),),)
                              ))

                            ],
                          ),
                           width:MediaQuery.sizeOf(context).width*0.8,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(25)
                    
                  ),
                        ),
                 
            
                ),
                
              ) ),
              
          ),
        ],
      )
    );
  }
}