import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:togetherness/models/user.dart';
import 'package:togetherness/pages/HomePage.dart';
import 'package:togetherness/widgets/HeaderWidget.dart';
import 'package:togetherness/widgets/ProgressWidget.dart';
class Dashboard extends StatefulWidget {
  final String userProfileId;
  Dashboard({this.userProfileId});

  @override
  _DashboardState createState() => _DashboardState();
}

Column createColumns(String title,int count){
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        count.toString(),
        style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.black),
      ),
      Container(
        margin: EdgeInsets.only(top: 5.0),
        child: Text(
          title,
          style: TextStyle(fontSize: 16.0,color: Colors.black,fontWeight: FontWeight.w400),
        ),
      ),
    ],
  );
}

class _DashboardState extends State<Dashboard> {
  final String currentOnlineUserId = currentUser?.id;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,strTitle: "My Dashboard"),
      body: FutureBuilder(
        future: usersReference.document(widget.userProfileId).get(),
        builder: (context,dataSnapshot){
          if(!dataSnapshot.hasData){
            return circularProgress();
          }
          User user = User.fromDocument(dataSnapshot.data);
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 45.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(user.url),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              createColumns("Events",totalEvents),
                              createColumns("Rating",avgRating),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Name: "+user.username,
                    style: TextStyle(fontSize: 18.0,color:Colors.black),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Profile Name: "+user.profileName,
                    style: TextStyle(fontSize: 18.0,color:Colors.black),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Email : "+user.email,
                    style: TextStyle(fontSize: 18.0,color:Colors.black),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Age: "+user.age,
                    style: TextStyle(fontSize: 18.0,color:Colors.black),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Phone number: "+user.phoneno,
                    style: TextStyle(fontSize: 18.0,color:Colors.black),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Location: "+user.location,
                    style: TextStyle(fontSize: 18.0,color:Colors.black),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
