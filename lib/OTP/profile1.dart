import 'dart:io'; // for File
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile1 extends StatefulWidget {
  const Profile1({
    Key? key,
  }) : super(key: key);

  @override
  State<Profile1> createState() => _Profile1State();
}

class _Profile1State extends State<Profile1> {
  List fetch = [];
  String? namefetch;

  String? place;
  String? number;
  String? age;
  String? image1;

  @override
  initState() {


 
 





  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.only(left: 40, right: 40),
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    image1 != null
                        ? CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(image1!),
                      radius: 60,
                    )
                        : CircleAvatar(
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Icon(
                          Icons.person,
                          size: 100,
                        ),
                      ),
                      radius: 60,
                    ),
                    Container(
                      height: 40,
                      width: 80,
                      child: ElevatedButton(
                          style:
                          ElevatedButton.styleFrom(shape: StadiumBorder()),
                          onPressed: () async {
                            File imagefile1;
                            final ImagePicker _picker = ImagePicker();
                            PickedFile? image2 = await _picker.getImage(
                                source: ImageSource.gallery);
                            imagefile1 = File("${image2?.path}");
                            FirebaseStorage fs = FirebaseStorage.instance;
                            Reference ref =
                            fs.ref().child('Image').child('image');
                            UploadTask uploadTask = ref.putFile(imagefile1);
                            uploadTask.then((res) async {
                              String link = await res.ref.getDownloadURL();

                              DatabaseReference _testref =
                              FirebaseDatabase.instance.ref();
                              _testref
                                  .child('/Data/Image/')
                                  .update({'Image': '${link}'});
                              setState(() {
                                image1 = link;
                              });
                            });
                          },
                          child: Text('Pick an Image')),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
            Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name:',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '$namefetch',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Place:',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '$place',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Age:',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '$age',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Number:',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '$number',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }


}

