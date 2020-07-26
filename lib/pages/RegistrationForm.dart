import 'package:flutter/material.dart';
import 'package:togetherness/widgets/HeaderWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationForm extends StatelessWidget
{

  final String event_id;
RegistrationForm({this.event_id});
Widget build(BuildContext context)
{
  return MaterialApp
    (
    debugShowCheckedModeBanner:false,
    title: 'Flutter Registration UI',
    theme: ThemeData
      (
      primarySwatch: Colors.yellow,

    ),
    home: Registration(event_name:this.event_id),
  );
}
}
class Registration extends StatefulWidget
{final String event_name;

Registration( {this.event_name});
@override
_RegistrationState createState() => _RegistrationState(event_name:this.event_name);
}

class _RegistrationState extends State<Registration>
{
  final String event_name;
  final myController = TextEditingController();
  _RegistrationState({this.event_name});
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      key: _scaffoldKey,
      appBar: header(context,strTitle: "Registration Form",disappearBackButton: true),
      body: Center
        (
        child: Column
          (
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisAlignment:MainAxisAlignment.start,
          children:<Widget>
          [
            Text("Registration Form",style: TextStyle(color:Colors.red)),
            Container
              (
              //padding:EdgeInsets.symmetric(vertical:16.0,horizontal:16.0),
              child:Divider(),
            ),
            Container
              (
              //padding:EdgeInsets.symmetric(vertical:20.0,horizontal:20.0),
              child:TextField(
                controller:myController,
                maxLines: 5,
                decoration:InputDecoration(
                  labelText:"Why you want to register",
                  enabledBorder:OutlineInputBorder(
                    borderSide:BorderSide(
                      color:Colors.blue,
                    ),
                  ),
                  border:OutlineInputBorder(),
                ),

              ),
            ),
            Container
              (
              //padding:EdgeInsets.symmetric(vertical:16.0,horizontal:8.0),
              child:MaterialButton(
                child:Text('Register'),
                color:Colors.yellow,
                onPressed:() {
                  print(Text(myController.text));
                  print(event_name);
                  Firestore.instance.collection("events").document(event_name).updateData({
                    "pending" : FieldValue.arrayUnion([{"description":myController.text,"userid":"123232","username":"loyal"}])
                  }).then((_) {
                    SnackBar snackBar = SnackBar(content: Text("Successfully Submitted"),);
                    _scaffoldKey.currentState.showSnackBar(snackBar);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}