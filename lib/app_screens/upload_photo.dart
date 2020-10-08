import 'package:blog_app/app_screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadPhoto extends StatefulWidget {
  @override
  _UploadPhotoState createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {

  //--------------------------------------Variables----------------------------------------------------//
  File _sampleImage;
  var _formKey = GlobalKey<FormState>();
  String _description;
  String _url;

  //--------------------------------------Working Methods----------------------------------------------------//
  Future _getImage() async {
    var tempImg = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _sampleImage = tempImg;
    });
  }

  bool _validateAndSave(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  void _uploadStatusImage() async {
    if(_validateAndSave()){
      //upload image to Storage
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");
      var timeKey = DateTime.now();     //the time will work as unique key for image
      final StorageUploadTask uploadTask = postImageRef.child("${timeKey.toString()}.jpg").putFile(_sampleImage);

      //Get the download url
      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      _url = imageUrl.toString();
      _goToHomePage();
      _saveToDatabase(_url);
    }
  }

  void _goToHomePage(){
    Navigator.pop(context, true);
    // Navigator.of(context).push(MaterialPageRoute(builder: (context){
    //   return HomePage();
    // }));
  }

  void _saveToDatabase(String url){
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat("MMM d, yyyy");
    var formatTime = DateFormat("EEEE, hh:mm aaa");

    String date = formatDate.format(dbTimeKey).toString();
    String time = formatTime.format(dbTimeKey).toString();

    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    var data = {
      "image" : url,
      "description" : _description,
      "date" : date,
      "time" : time 
    };
    databaseReference.child("Posts").push().set(data);
  }

  //--------------------------------------Design-------------------------------------------------------//
  Widget _enableUpload(){
    return Container(
      margin: const EdgeInsets.all(18.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Image.file(_sampleImage, width: double.infinity, height: 320.0, fit: BoxFit.cover,),
                SizedBox(height: 16.0,),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Description",
                  ),
                  validator: (value) => value.isEmpty ? "Description is required" : null,
                  onSaved: (value) => _description = value,
                ),
                SizedBox(height: 16.0,),
                RaisedButton(
                  elevation: 10.0,
                  textColor: Colors.white,
                  color: Colors.pink,
                  child: Text("Add a New Post"),
                  onPressed: _uploadStatusImage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Image",
        child: Icon(Icons.add_a_photo),
        onPressed: _getImage,
      ),
      body: Center(
        child: _sampleImage == null ? Text("Select an Image") : _enableUpload(),
      ),
    );
  }
}