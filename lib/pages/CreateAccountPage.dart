import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:togetherness/widgets/HeaderWidget.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController locationTextEditingController = TextEditingController();
  String username;
  String age;
  String phoneno;
  String location;
  submitDetails(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      SnackBar snackBar = SnackBar(content: Text("Welcome "+username),);
      _scaffoldKey.currentState.showSnackBar(snackBar);

      Timer(Duration(seconds: 2),(){
        Navigator.pop(context,{"username":username,"age":age,"phoneno":phoneno,"location":location});
      });
    }
  }

  getUserCurrentLocation() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMarks = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlaceMark= placeMarks[0];
    String completeAddressInfo = '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare},${mPlaceMark.subLocality} ${mPlaceMark.locality}, ${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, ${mPlaceMark.postalCode} ${mPlaceMark.country},';
    String specificAddress = '${mPlaceMark.locality} ${mPlaceMark.country}';
    locationTextEditingController.text = specificAddress;
  }
  @override
  Widget build(BuildContext parentContext) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context,strTitle: "Settings",disappearBackButton: true),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 26.0),
                  child: Center(
                    child: Text("Set up Personal Info",style: TextStyle(fontSize: 26.0),),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            validator: (val){
                              if(val.trim().length<5 || val.isEmpty){
                                return "Username is very short.";
                              }
                              else if(val.trim().length>15){
                                return "Username is very long.";
                              }
                              else{
                                return null;
                              }
                            },
                            onSaved: (val)=>username=val,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.person),
                              labelText: "Username",
                              labelStyle: TextStyle(fontSize: 16.0),
                              hintText: "must be at least 5 characters",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            validator: (val){
                              String pattern = r'(^[0-9]*$)';
                              RegExp regExp = new RegExp(pattern);
                              if(val.isEmpty){
                                return "Age cannot be empty.";
                              }
                              else if(!regExp.hasMatch(val)){
                                return "Age cannot contain characters other than numbers.";
                              }
                              else{
                                return null;
                              }
                            },
                            onSaved: (val)=>age=val,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              icon: Icon(Icons.calendar_view_day),
                              border: OutlineInputBorder(),
                              labelText: "Age",
                              labelStyle: TextStyle(fontSize: 16.0),
                              hintText: "must be a number",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            validator: (val){
                              String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                              RegExp regExp = new RegExp(pattern);
                              if(val.isEmpty){
                                return "Phone number required.";
                              }
                              else if (!regExp.hasMatch(val)) {
                                  return 'Please enter valid mobile number';
                              }
                              else
                                  return null;
                              },
                            onSaved: (val)=>phoneno=val,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              icon: Icon(Icons.phone_android),
                              border: OutlineInputBorder(),
                              labelText: "Phone Number",
                              labelStyle: TextStyle(fontSize: 16.0),
                              hintText: "must be 10 digits",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: locationTextEditingController,
                            validator: (val){
                              if(val.isEmpty){
                                return "Location required.";
                              }
                              else{
                                return null;
                              }
                            },
                            onSaved: (val)=>location=val,
                            decoration: InputDecoration(
                              labelText: "Location",
                              labelStyle: TextStyle(fontSize: 16.0),
                              hintText: "Write the location",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                          Container(
                            width:50.0,
                            height: 30.0,
                            child: RaisedButton.icon(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                              color: Colors.green,
                              icon: Icon(Icons.location_on,color: Colors.black,),
                              label: Text("Get Current location",style: TextStyle(color:Colors.white),),
                              onPressed: getUserCurrentLocation,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: submitDetails,
                  child: Container(
                    height: 55.0,
                    width: 360.0,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        "Proceed",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}