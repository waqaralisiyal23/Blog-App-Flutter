import 'package:blog_app/app_screens/upload_photo.dart';
import 'package:blog_app/models/post.dart';
import 'package:blog_app/utils/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //--------------------------------------Variables----------------------------------------------------//
  AuthImplementation _auth = Auth();
  List<Post> _postList = List<Post>();
  int _count = 0;
  DatabaseReference _postsRef = FirebaseDatabase.instance.reference().child("Posts");

  //--------------------------------------Working Methods----------------------------------------------------//
  // void _updateListView() {
  //   DatabaseReference postsRef = FirebaseDatabase.instance.reference().child("Posts");
  //   postsRef.once().then((DataSnapshot datasnapshot){
  //     var keys = datasnapshot.value;
  //     print("Key = ${keys}");
  //     var data = datasnapshot.value;
  //     data.for (var item in items) {
        
  //     };

  //     _postList.clear();

  //     for(var i in data){
  //       var value = data[i];
  //       print("Value &value");
  //       Post post = Post(
  //         value['image'],
  //         value['description'],
  //         value['date'],
  //         value['time']
  //       );
  //       _postList.add(post);
  //     }
  //     setState(() {
  //       _count = _postList.length;
  //     });
  //    });
  // }

  @override
  void initState() {
    super.initState();
  }

  void _logoutUser() async {
    try{
      await _auth.signOut();
    }
    catch(e){
      print("Error: ${e.toString()}");
    }
  }

  void _moveToUploadPage() async {
    bool result = await Navigator.of(context).push(MaterialPageRoute(builder: (context){
     return UploadPhoto();
    }));
  }

  //--------------------------------------Design-------------------------------------------------------//
  Widget _postUI(String image, String description, String date, String time){
    return Card(
      elevation: 10.0,
      margin: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 10.0,),
            Image.network(image, width: double.infinity, height: 300.0, fit: BoxFit.cover,),
            SizedBox(height: 10.0,),
            Text(
              description,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
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
        title: Text("Home"),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.pink,
        child: Container(
          margin: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.local_car_wash, size: 40.0, color: Colors.white,),
                onPressed: _logoutUser,
              ),
              IconButton(
                icon: Icon(Icons.add_a_photo, size: 40.0, color: Colors.white,),
                onPressed: _moveToUploadPage,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: StreamBuilder(
          stream: _postsRef.onValue,            
          builder: (context, AsyncSnapshot<Event> snapshot){
            if(snapshot.hasData){
              _postList.clear();
              DataSnapshot dataSnapshot = snapshot.data.snapshot;
              Map<dynamic, dynamic> values = dataSnapshot.value;
              if(values!=null){
                values.forEach((key, value) {
                  Post post = Post(
                    values[key]['image'], 
                    values[key]['description'], 
                    values[key]['date'], 
                    values[key]['time']
                  );
                  _postList.add(post);
                });
                return ListView.builder(
                  itemCount: _postList.length,
                  itemBuilder: (BuildContext context, int position){
                    return _postUI(
                      _postList[position].image, 
                      _postList[position].description, 
                      _postList[position].date, 
                      _postList[position].time
                    );
                  },
                );
              }
              else{
                return Center(
                  child: Text("No Blog Post Available"),
                );
              }
            }
            else{
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}