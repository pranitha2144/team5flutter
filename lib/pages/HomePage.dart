import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:togetherness/models/user.dart';
import 'package:togetherness/pages/ActiveEventsPage.dart';
import 'package:togetherness/pages/AllEvents.dart';
import 'package:togetherness/pages/CreateAccountPage.dart';
import 'package:togetherness/pages/DashboardPage.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
final usersReference = Firestore.instance.collection("users");
final DateTime timestamp = DateTime.now();
final int avgRating=0;
final int totalEvents =0;
final registered_events = [];
final approved_events = [{"name":"","rating":0}];
User currentUser ;
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSignedIn = false;
  PageController pageController;

  void initState(){
    super.initState();

    pageController = PageController();

    gSignIn.onCurrentUserChanged.listen((gSigninAccount) {
      controlSignIn(gSigninAccount);
    },onError: (gError){
      print("Error Message: "+gError);
    });

    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }).catchError((gError){
      print("Error Message: "+gError);
    });
  }

  controlSignIn(GoogleSignInAccount signInAccount) async{
    if(signInAccount!=null){
      await saveUserInfoToFireStore();
      setState(() {
        isSignedIn = true;
      });
    }
    else{
      setState(() {
        isSignedIn = false;
      });
    }
  }

  saveUserInfoToFireStore() async{
        final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
        DocumentSnapshot documentSnapshot = await usersReference.document(gCurrentUser.id).get();

        if(!documentSnapshot.exists){
          final data = await Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateAccountPage()));
         // print("back home");

          usersReference.document(gCurrentUser.id).setData({
            "id" : gCurrentUser.id,
            "profileName":gCurrentUser.displayName,
            "username":data['username'],
            "url":gCurrentUser.photoUrl,
            "email":gCurrentUser.email,
            "age":data["age"],
            "phoneno":data["phoneno"],
            "location":data["location"],
            "approved_events":approved_events,
            "registered_events":registered_events,
            "timestamp": timestamp,
          });

          documentSnapshot = await usersReference.document(gCurrentUser.id).get();
        }
        currentUser = User.fromDocument(documentSnapshot);
      }
  loginUser(){
    gSignIn.signIn();
  }

  logoutUser(){
    gSignIn.signOut();
  }


  Scaffold buildHomeScreen(){
    //return RaisedButton.icon(onPressed: logoutUser,icon: Icon(Icons.close),label: Text("Sign Out"),);

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(currentUser.username),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      radius: 45.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(currentUser.url),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white12,
              ),
            ),
            ListTile(
              title: Text("My Active Events"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ActiveEvents(userProfileId:currentUser.id)));
              },

            ),

            ListTile(
              title: Text("All Events"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AllEvents(userProfileId:currentUser.id)));
              },
            ),
            ListTile(
              title: Text("My Dashboard"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard(userProfileId:currentUser.id)));
              },
            ),
            ListTile(
              title: Text("logout"),
              onTap: (){
                SnackBar snackBar = SnackBar(content: Text("Logout Successfully"),);
                _scaffoldKey.currentState.showSnackBar(snackBar);
                logoutUser();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(),
      body: Text("hello user"),
    );
  }

  Scaffold buildSignInScreen(){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Theme.of(context).accentColor,Theme.of(context).primaryColor],
            )
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Togetherness",style: TextStyle(fontSize: 72.0,fontFamily: "Signatra",color: Colors.white),
            ),
            GestureDetector(
              onTap: loginUser,
              child: Container(
                width: 270.0,
                height: 65.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/google_signin_button.png"),
                      fit: BoxFit.cover,
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(isSignedIn){
      return buildHomeScreen();
    }
    else{
      return buildSignInScreen();
    }
  }
}