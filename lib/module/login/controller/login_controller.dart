import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:photography_app/core.dart';
import 'package:photography_app/module/shared/show_info_dialog.dart';
// import 'package:photography_app/module/dashboard/widget/navbar.dart';
// import 'package:photography_app/state_util.dart';
// import '../view/login_view.dart';

class LoginController extends State<LoginView> implements MvcController {
  static late LoginController instance;
  late LoginView view;

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) => widget.build(context, this);

  String email = "";
  String password = "";

  doLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Get.offAll(const MainNavigationView());
    } on Exception {
      showInfoDialog("Email atau Password salah");
      // print(err);

    }
  }

  doGoogleLogin() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );

    try {
      await googleSignIn.disconnect();
    } catch (_) {}

    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      var userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      debugPrint("userCredential: $userCredential");

      if (FirebaseAuth.instance.currentUser!.email !=
          "muhammadyusufnew16@gmail.com") {
        Get.offAll(const MainNavigationView());
      } else {
        Get.offAll(const AdmMainNavigationView());
      }
    } catch (_) {
      showInfoDialog("Gagal login");
    }
  }
}
