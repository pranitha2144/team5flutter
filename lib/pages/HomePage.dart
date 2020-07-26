import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:togetherness/models/user.dart';
import 'package:togetherness/pages/ActiveEventsPage.dart';
import 'package:togetherness/pages/CreateAccountPage.dart';
import 'package:togetherness/pages/DashboardPage.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
final usersReference = Firestore.instance.collection("users");
final DateTime timestamp = DateTime.now();
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
              child: Text(currentUser.username),
              decoration: BoxDecoration(
                color: Colors.white12,
              ),
            ),
            ListTile(
              title: Text("My Active Events"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ActiveEvents()));
              },

            ),
            ListTile(
              title: Text("My Registered Events"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ActiveEvents()));
                //change tha class name according to the class name in pages/pagename.dart file
              },
            ),
            ListTile(
              title: Text("All Events"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ActiveEvents()));
                //change tha class name according to the class name in pages/pagename.dart file
              },
            ),
            ListTile(
              title: Text("My Dashboard"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard()));
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
    print(isSignedIn);
    if(isSignedIn){
      return buildHomeScreen();
    }
    else{
      return buildSignInScreen();
    }
  }
}