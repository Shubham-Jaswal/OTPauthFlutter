import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otpauthflutter/OTP/profile.dart';

enum Mobileverification {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}



class Otppaeges extends StatefulWidget {
  const Otppaeges({Key? key}) : super(key: key);

  @override
  State<Otppaeges> createState() => _OtppaegesState();
}

class _OtppaegesState extends State<Otppaeges> {
  String numbertosend='';
  bool validate=false;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  String value = "";
  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? verificationID;
  bool showLoading=false;
  Mobileverification currentState=Mobileverification.SHOW_MOBILE_FORM_STATE;
  void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthcredentials) async{
    setState((){
      showLoading=true;
    });

    try {
      final authCredential=await _auth.signInWithCredential(phoneAuthcredentials);
      setState((){
        showLoading=false;
      });
      if(authCredential.user !=null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(number:numbertosend)));
      }
    } on FirebaseException catch (e) {
      // TODO
      setState((){
        showLoading=false;
      });
      Fluttertoast.showToast(msg: '${e.message}');
    }


  }

  getMobileformwidget(context){
return Form(
  key: _formkey,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Enter Your number',
        style: TextStyle(fontSize: 19),
      ),
      SizedBox(
        height: 30,
      ),
      Container(
        margin: EdgeInsets.only(right: 40, left: 40),
        child: TextFormField(onChanged:(value){
          value=numbertosend;
          numbertosend=controller.text;
        } ,
         keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter Number',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              )),
          controller: controller,
          validator: (value) {

            if (value!.isNotEmpty && value.length > 11) {
              return 'Please enter a 10 digit number';
            } else if (value.isNotEmpty && value.length < 10) {
              return 'Please!!';
            } else if (value.isEmpty) {
              return 'Dont leave empty';
            } else {
              return null;
            }
          },
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        height: 50,
        width: 200,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                primary: Colors.grey,
                onPrimary: Colors.black),
            onPressed: () async {
              validatenumber();
              if(validate==true)
                {

                  setState((){showLoading=true;});
                  await _auth.verifyPhoneNumber(phoneNumber:'+91 ${controller.text}',
                    verificationCompleted: (phoneAuthcredentials) async {
                      setState((){showLoading=false;});
                      //signInWithPhoneAuthCredential(phoneAuthcredentials);

                    },

                    verificationFailed: (verificationFailed) async {
                      Fluttertoast.showToast(msg: '${verificationFailed.message}');
                      setState((){showLoading=false;});
                    },

                    codeSent: (verificationID,resendingToken) async {
                      setState((){
                        showLoading=false;
                        currentState=Mobileverification.SHOW_OTP_FORM_STATE;
                        this.verificationID=verificationID;});


                    },

                    codeAutoRetrievalTimeout: (verificationID)async {}
                );}




            },
            child: Text('Get OTP')),
      ),

    ],
  ),
);

  }

  getOtpformwidget(context){
    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Enter Your OTP',
            style: TextStyle(fontSize: 19),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.only(right: 40, left: 40),
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter OTP',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
              controller: controller1,
              validator: (value) {
                if (value!.isNotEmpty && value.length > 6) {
                  return 'Please enter a 6 digit code';
                } else if (value.isNotEmpty && value.length < 6) {
                  return 'Please!!';
                } else if (value.isEmpty) {
                  return 'Dont leave empty';
                } else {
                  return null;
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            width: 200,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    primary: Colors.grey,
                    onPrimary: Colors.black),
                onPressed: () async {
                  validateOTP();
                  PhoneAuthCredential phoneAuthcredentials=PhoneAuthProvider.credential(
                      verificationId: verificationID!, smsCode: controller1.text);
                  signInWithPhoneAuthCredential(phoneAuthcredentials);
                },
                child: Text('Verify OTP')),
          ),
        ],
      ),
    );



  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

         child:showLoading ? Center(child: CircularProgressIndicator(),):
         currentState==Mobileverification.SHOW_MOBILE_FORM_STATE?
         getMobileformwidget(context): getOtpformwidget(context)


      )
    );
  }
  void validatenumber(){

    if (_formkey.currentState!.validate()) {
      validate=true;

    }

    else {
      validate=false;
      Fluttertoast.showToast(msg: 'Enter a 10 digit number');
    }
  }
  void validateOTP(){
    if (_formkey.currentState!.validate()) {
      validate = true;
      DatabaseReference _testref =
      FirebaseDatabase.instance.ref();
      _testref.child('/Data/OK/').set({'Number': '9'});
      _testref.child('/Data/${controller.text}/').update({'Name':'Daniel'});
      _testref.child('/Data/${controller.text}/').update({'Place':'London'});
      _testref.child('/Data/${controller.text}/').update({'Age':'20'});
      setState(() {});
    }

    else {
      validate=false;
      Fluttertoast.showToast(msg: 'Enter a 6 digit code');
    }
  }


}
