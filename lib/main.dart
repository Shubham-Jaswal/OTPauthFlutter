import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otpauthflutter/OTP/otppages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:otpauthflutter/OTP/profile.dart';
import 'package:otpauthflutter/OTP/profile1.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home:InitializerWidget(),
  ));
}

class InitializerWidget extends StatefulWidget {
  const InitializerWidget({Key? key}) : super(key: key);

  @override
  State<InitializerWidget> createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  FirebaseAuth? _auth;
  User? _user;
  bool isLoading = false;

  @override
  initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth?.currentUser;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),

    ) : _user==null?Otppaeges():Profile(number:"ok",);
  }

}
