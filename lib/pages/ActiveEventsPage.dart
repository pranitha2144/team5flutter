import 'package:flutter/material.dart';
import 'package:togetherness/pages/HomePage.dart';
import 'package:togetherness/widgets/HeaderWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ActiveEvents extends StatefulWidget {
  final String userProfileId;
  ActiveEvents({this.userProfileId});
  @override
  _ActiveEventsState createState() => _ActiveEventsState(userId:this.userProfileId);
}

class _ActiveEventsState extends State<ActiveEvents> {
  final String userId;
  _ActiveEventsState({this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, strTitle: "My Active Events"),
        body: new EventList(userId:this.userId)// to hide backbutton send disappearbackbutton parameter as TRUE
    );
  }

}

class EventList extends StatelessWidget {
  final String userId;
  EventList({this.userId});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').where('userid',isEqualTo: "104938209637048378257").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
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
                                document['regsistered_events'],
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


                                ]
                            ),


                            SizedBox(height:10.0 ,),

                          ],
                        ),
                      )

                  );
                }).toList()


            );
        }
      },
    );
  }
}