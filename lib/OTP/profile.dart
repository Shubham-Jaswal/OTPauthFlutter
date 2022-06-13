import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otpauthflutter/OTP/otppages.dart';
import 'package:otpauthflutter/OTP/profile1.dart';

class Profile extends StatefulWidget {
   String? number;

   Profile({Key? key, required this.number}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState(number);
}

class _ProfileState extends State<Profile> {
  String? number;
  _ProfileState(this.number);

  final _auth = FirebaseAuth.instance;
   XFile? _image;
   String? imagelink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50,),
            imagelink !=null?
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(imagelink!),
              radius: 60,
            ):
        CircleAvatar(
          backgroundColor: Colors.white,
        child: ClipOval(
        child: Icon(
        Icons.person,
        size: 100,
      ),
    ),
    radius: 60,
    ),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: ((){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile1()));
            }), child: Text('Check Profile')),


            SizedBox(height: 100,),
            Container(
              height: 50,
              width: 200,
              child: ElevatedButton(
                onPressed: () async {
                /*  File imagefile;
                  final ImagePicker _picker = ImagePicker();
                 PickedFile? image = await _picker.getImage(source: ImageSource.gallery);
                 imagefile=File("${image?.path}");
                 FirebaseStorage fs=FirebaseStorage.instance;
                 Reference ref=fs.ref().child('Image').child('image');
                  UploadTask uploadTask = ref.putFile(imagefile);
                  uploadTask.then((res) async {
                  String link= await res.ref.getDownloadURL();

                  DatabaseReference _testref =
                  FirebaseDatabase.instance.ref();
                  print(number);
                  _testref.child('/Data/${number}/').update({'Image':  '${link}'});
                  _testref.child('/Data/${number}/').update({'Number1':  '${number}'});
                  setState((){
                    imagelink=link;
                  }
                  );
                  });*/

                },
                child: Text('Pick an Image'),
              ),
            ),
            SizedBox(height: 50,),
            Container(
              height: 50,
              width: 200,
              child: ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Otppaeges()));

                },
                child: Text('Signout'),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
