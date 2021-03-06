import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:payparking_app/utils/db_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'parkingTransList.dart';

class UpdateTrans extends StatefulWidget {
  final String id;
  final String plateNo;
  final String amount;
  final String location;
  final String username;

  UpdateTrans({Key key, @required this.id, this.plateNo, this.amount,this.location,this.username}) : super(key: key);
  @override
  _UpdateTrans createState() => _UpdateTrans();
}
class _UpdateTrans extends State<UpdateTrans>{


  final db = PayParkingDatabase();
  File pickedImage;
//  bool pressed = true;
  String locationA = "Location";
  var wheel = 0;
  Color buttonBackColorA;
  Color textColorA = Colors.black45;
  Color buttonBackColorB;
  Color textColorB = Colors.black45;
  setWheelA() {
    setState(() {
      buttonBackColorA = Colors.lightBlue;
      buttonBackColorB = Colors.transparent;
      textColorA = Colors.black45;
      wheel = 50;
    });
  }

  setWheelB() {
    setState(() {
      buttonBackColorB = Colors.lightBlue;
      buttonBackColorA = Colors.transparent;
      textColorB = Colors.black45;
      wheel = 100;
    });
  }

  List<Widget> _getList() {
    String location = widget.location;
    var locCount = location.split(",").length;
    var locSplit = location.split(",");
    var counter  = locCount;

    counter = counter-1;

    List<Widget> temp = [];
    for(var q = 0; q < locCount; q++) {
      temp.add(
        FlatButton(
          child: new Text(locSplit[q]),
          onPressed: () {
            setState(() {
              Navigator.of(context, rootNavigator: true).pop('dialog');
              locationA = locSplit[q];
            });
          },
        ),
      );
      if(q >= counter){

        temp.add(
          FlatButton(
            child: new Text("Close "),
            onPressed: () {
              setState(() {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                locationA = 'Location';
              });
            },
          ),
        );
      }
    }
    return temp;
  }


  void addLocation(){
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          title: Text('Add Location'),
          actions:  _getList(),
//            <Widget>[

//              FlatButton(
//                child: new Text("Location A"),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                  locationA = 'Location A';
//                },
//              ),
//              FlatButton(
//                child: new Text("Location B"),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                  locationA = 'Location B';
//                },
//              ),
//              FlatButton(
//                child: new Text("Location C"),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                  locationA = 'Location C';
//                },
//              ),
//              FlatButton(
//                child: new Text("Location D"),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                  locationA = 'Location D';
//                },
//              ),
//              FlatButton(
//                child: new Text("Close & Clear"),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                  locationA = 'Add Location';
//                },
//              ),
//            ],
        );
      },
    );
  }




  TextEditingController plateNoController = TextEditingController();

  void confirmed(){
    if(plateNoController.text == "" || locationA == "Location"){
//      var today = new DateTime.now();
//      var dateToday = DateFormat("yyyy-MM-dd").format(new DateTime.now());
//      var dateUntil = DateFormat("yyyy-MM-dd").format(today.add(new Duration(days: 7)));
//      print(dateToday);
//      print(dateUntil);
//      print(selectedRadio);
    }
    else {
      if(wheel == 0){

      }
      else{
        saveData();
      }
    }
  }

  void saveData() async{

    bool result = await DataConnectionChecker().hasConnection;
    String plateNumber = plateNoController.text;
    var id = widget.id;


    if(result == true){
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return CupertinoAlertDialog(
            title: new Text(plateNoController.text),
            content: new Text("Successfully Updated"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed:(){
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  plateNoController.text = "";
                },
              ),
            ],
          );
        },
      );
      await db.olUpdateTransaction(id,plateNumber,wheel,locationA);
//      await db.addTrans(plateNumber,dateToday,dateTimeToday,dateUntil,amount,user,stat);
      locationA = "Location";
    }
    else{
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return CupertinoAlertDialog(
            title: new Text("Connection Problem"),
            content: new Text("Please Connect to the wifi hotspot or turn the wifi on"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

            ],
          );
        },
      );
    }
  }


  String name;
  @override
  void initState(){
    super.initState();
    plateNoController.text = widget.plateNo;
    //mo prompt if na setupan na ug location or naay internet
  }




  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,

        title: Text('Edit',style: TextStyle(fontWeight: FontWeight.bold,fontSize: width/28, color: Colors.black),),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {},
            child: Text(widget.username.toString(),style: TextStyle(fontSize: width/36,color: Colors.black),),
          ),
        ],
        textTheme: TextTheme(
            title: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
            )
        ),
      ),
      body: ListView(
//          physics: BouncingScrollPhysics(),
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
//             child:NiceButton(
//                width: 255,
//                elevation: 0.0,
//                radius: 52.0,
//                fontSize: 18.0,
//                text: "Open Camera",
//                icon: Icons.camera_alt,
//                padding: const EdgeInsets.all(15),
//                background: Colors.blue,
//                onPressed:pickImage,
//             ),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
            child: new TextFormField(
              controller:plateNoController,
              autofocus: false,
//               enabled: false,
              style: TextStyle(fontSize: width/15),
              decoration: InputDecoration(
                hintText: 'Plate Number',
                contentPadding: EdgeInsets.all(width/15.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                suffixIcon: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 30.0),
                  child:  Icon(Icons.format_list_numbered, color: Colors.grey,size: 40.0,),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.transparent,
            height:15.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 35.0),
            child:Text('Vehicle Type & Location',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Colors.black45),),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child:Column(
                  children: <Widget>[
                    FlatButton.icon(
                      label: Text('4 wheels'.toString(),style: TextStyle(fontSize: width/33.0, color: textColorA),),
                      splashColor: Colors.lightBlue,
                      color: buttonBackColorB,
                      icon: Icon(Icons.directions_car, color: textColorA,size: width/20.0,),
                      padding: EdgeInsets.symmetric(horizontal: width/20.0,vertical: 5.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(35.0),
                          side: BorderSide(color: Colors.lightBlue)
                      ),
                      onPressed:(){
                        setWheelB();
                      },
                    ),
                    Text("   "),
                    FlatButton.icon(
                      label: Text('2 wheels'.toString(),style: TextStyle(fontSize: width/33.0, color: textColorB),),
                      splashColor: Colors.lightBlue,
                      color: buttonBackColorA,
                      icon: Icon(Icons.motorcycle, color: textColorB,size: width/20.0,),
                      padding: EdgeInsets.symmetric(horizontal:width/20.0,vertical: 5.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(35.0),
                          side: BorderSide(color: Colors.lightBlue)
                      ),
                      onPressed:(){
                        setWheelA();
                      },
                    ),
                    Text("   "),
                    FlatButton.icon(
                      label: Text(locationA.toString(),style: TextStyle(fontSize: width/33.0, color: Colors.black45),),
                      splashColor: Colors.lightBlue,
                      icon: Icon(Icons.location_on, color: Colors.black45,size: width/20.0,),
                      padding: EdgeInsets.symmetric(horizontal:width/20.0,vertical: 5.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(35.0),
                          side: BorderSide(color: Colors.lightBlue)
                      ),
                      onPressed: addLocation,
                    ),
                  ]),

          ),


          Padding( padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20.0),
            child: Container(
//              width: 400.0,
              child: ConfirmationSlider(
                shadow:BoxShadow(color: Colors.black38, offset: Offset(1, 0),blurRadius: 1,spreadRadius: 1,),
                foregroundColor:Colors.blue,
                height: height/6,
                width : width-50,
                onConfirmation: () => confirmed(),
              ),),
          ),
        ],
      ),
    );
  }
}