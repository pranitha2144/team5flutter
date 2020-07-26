import 'package:flutter/material.dart';
import 'dart:async';
import 'package:togetherness/widgets/HeaderWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:togetherness/pages/RegistrationForm.dart';
class AllEvents extends StatefulWidget {
  final String userProfileId;
  AllEvents({this.userProfileId});
  @override
  _AllEventsState createState() => _AllEventsState();
}
class EventDetails {
  Timestamp date;
  String desc;
  String organizer;
  String location;
  String name;
  String theme;
  String eventID;
  EventDetails({this.date, this.desc, this.organizer,this.location,this.name,this.theme,this.eventID});
}
class _AllEventsState extends State<AllEvents> {
  Future getEvents()
  async {
    final firestoreInstance = Firestore.instance;

    QuerySnapshot qn= await firestoreInstance.collection("events").getDocuments();
//    print(qn.documents[0]);
    return qn.documents;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Events"),),
      body: Container(
        child: FutureBuilder(future:getEvents() ,builder: (_, snapshot){
          if (snapshot.connectionState==ConnectionState.waiting)
          {
            return Center(
              child: Text("Loading..."),
            );
          }
          else
          {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_,index){
                  DateTime myDateTime = DateTime.parse(snapshot.data[index].data["date"].toDate().toString());
                  return new Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 10.0,
                      margin: EdgeInsets.all(15.0),
                      child: new Container(
                        padding: new EdgeInsets.all(14.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Container(
                              color: Colors.black,
                              alignment: Alignment(0.0, 0.0),
                              child: new Text(
                                snapshot.data[index].data["name"],
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 30.0,
                                    color: Colors.white
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height:10.0 ,),
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children :<Widget>[
                                  new Text(
                                    myDateTime.toString(),
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic),
                                    textAlign: TextAlign.center,
                                  ),
                                  new Text(
                                    snapshot.data[index].data["location"] ,
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic),
                                    textAlign: TextAlign.center,
                                  )
                                ]
                            ),


                            SizedBox(height:10.0 ,),
                            new Text(
                              snapshot.data[index].data["description"],
                              style: TextStyle(
                                  fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center,
                            ),
                            new Container(
                                child: MaterialButton(
                                  child:Text('Register'),
                                  color:Colors.yellow,
                                  onPressed:() {
                                    final event= EventDetails(date:snapshot.data[index].data["date"],desc:snapshot.data[index].data["description"],organizer:snapshot.data[index].data["email"],location:snapshot.data[index].data["location"],name:snapshot.data[index].data["name"],theme:snapshot.data[index].data["theme"],eventID: snapshot.data[index].data.documentID);
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailScreen(event_name: event,)));
                                    //change tha class name according to the class name in pages/pagename.dart file
                                  },
                                )
                            )
                          ],
                        ),
                      )

                  );
                });
          }
        }),
      ),
    );
  }
}
class DetailScreen extends StatelessWidget {
  // Declare a field that holds the events
  final EventDetails event_name;

  // In the constructor, require a event
  DetailScreen({this.event_name});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Details"),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        alignment: Alignment.centerLeft,
        child: Column(
          children: <Widget>[
            Container(
                height: 54.0,
                padding: EdgeInsets.all(12.0),
                alignment: Alignment.center,
                child: Text("Details for the event: ${event_name.name}",
                    style: TextStyle(fontWeight: FontWeight.w700))),
            Text("Theme: ${event_name.theme}"),
            Text("Description: ${event_name.desc}"),
            Text("Date: ${event_name.date}"),
            Text("Location: ${event_name.location}"),
            Text("organizer: ${event_name.organizer}"),
            Padding
              (
              padding:EdgeInsets.symmetric(vertical:16.0,horizontal:8.0),
              child:MaterialButton(
                child:Text("Go to registration"),
                color:Colors.blue,
                onPressed:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationForm(event_id: event_name.eventID,)),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
