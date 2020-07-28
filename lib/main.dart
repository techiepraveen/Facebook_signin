import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

void main()=> runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

bool _isloggedIn = false;
Map user;
final facebooklogin = FacebookLogin();

_logonwithfb() async {
  final result = await facebooklogin.logInWithReadPermissions(['email']);
  switch( result.status){
    case FacebookLoginStatus.loggedIn:
    final token =result.accessToken.token;
    final graphResponse =await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
    final profile = JSON.jsonDecode(graphResponse.body);
    print(profile);
    setState(() {
      user =profile;
      _isloggedIn =true;
    });
    break;

    case FacebookLoginStatus.cancelledByUser:
    setState(() {
      _isloggedIn = false;
    }
    );
    break;
    case FacebookLoginStatus.error:
    setState(() {
      _isloggedIn = false;
    });

  
  }

}

_logout(){
  facebooklogin.logOut();
  setState(() {
    _isloggedIn= false;
  });
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: _isloggedIn?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(user["picture"]["data"]["url"],height:50.0,width:50.0 ),
              SizedBox(
                height: 10.0,
              ),
              Text('Name:${user['name']}\nEmail:${user['email']}', 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                child: Text("Logout"),
                onPressed: (){
                  _logout();
                },
              ),
            ],
            
            
          )
          :Center(
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text("Login with Facebook"),
              onPressed: (){
                _logonwithfb();
              },
            ),
          )
        ),
        
      ),
      
    );
  }
}