import 'package:blog_app/app_screens/dialog_box.dart';
import 'package:blog_app/utils/authentication.dart';
import 'package:flutter/material.dart';

class LoginRegisterPage extends StatefulWidget {
  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

enum FormType{
  login,
  register
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {

  //--------------------------------------Variables----------------------------------------------------//
  final _formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;

  String _email = "";
  String _password = "";

  AuthImplementation _auth = Auth();

  //--------------------------------------Methods----------------------------------------------------//
  bool _validateAndSave(){
    final form = _formKey.currentState;

    if(form.validate()){
      form.save();                  //onSaved it will assign the values to _email and _password
      return true;
    }
    return false;
  }

  //For login
  void _validateAndSubmit() async {
    if(_validateAndSave()){
      try{
        if(_formType == FormType.login)
          String userId = await _auth.signIn(_email, _password);
        else
          String userId = await _auth.signUp(_email, _password);
      }
      catch(e){
        DialogBox.showDialogBox(context, "Error", e.toString());
      }
    }
  }

  void _moveToRegister(){
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void _moveToLogin(){
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  //--------------------------------------Design-------------------------------------------------------//
  Widget _logo(){
    return Hero(
      tag: "Hero",
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 110.0,
        child: Image.asset("images/app_logo.png"),
      ),
    );
  }

  List<Widget> _createInputs(){
    return [
      SizedBox(height: 10.0,),
      _logo(),
      SizedBox(height: 20.0,),
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: "Email",
        ),
        validator: (value) => value.isEmpty ? "Email is required" : null,
        onSaved: (value) => _email = value,
      ),
      SizedBox(height: 10.0,),
      TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Password",
        ),
        validator: (value) => value.isEmpty ? "Password is required" : null,
        onSaved: (value) => _password = value,
      ),
      SizedBox(height: 20.0,),
    ];
  }

  List<Widget> _createButtons(){
    if(_formType == FormType.login){
      return [
        RaisedButton(
          textColor: Colors.white,
          color: Colors.pink,
          child: Text(
            "Login",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          onPressed: _validateAndSubmit,
        ),
        FlatButton(
          textColor: Colors.red,
          child: Text(
            "Not have an account? Create Account",
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          onPressed: _moveToRegister,
        ),
      ];
    }
    else{
      return [
        RaisedButton(
          textColor: Colors.white,
          color: Colors.pink,
          child: Text(
            "Create Account",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          onPressed: _validateAndSubmit,
        ),
        FlatButton(
          textColor: Colors.red,
          child: Text(
            "Already have an account? Login",
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          onPressed: _moveToLogin,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog App"),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _createInputs() + _createButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}