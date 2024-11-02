import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:uber_driver/Screens/Splash_Screen.dart';
import 'package:uber_driver/core/global.dart';
import 'package:uber_driver/core/widgets.dart';
import 'package:uber_driver/mainScreens/Register_Screen.dart';
import 'package:uber_driver/core/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool isObscure = true;
  
  validateForm() {
    final RegExp emailExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailExp.hasMatch(emailController.text)) {
      FlutterToastr.show("Email Address is Not Valid", context);
    } else if (passController.text.length < 6) {
      FlutterToastr.show("Password Must be at least 6 Characters", context);
    } else {
      loginDriverNoe();
    }
  }

  loginDriverNoe() async {
    showDialog(context: context,barrierDismissible: false, builder: (context) {
      return ProgressDialog(message: "Processing, Please Wait...",);
    });
    final User? firebaseUser = (
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim()
      ).catchError((msg){
        Navigator.pop(context);
        FlutterToastr.show("Error: $msg", context);
      })
    ).user;

    if (firebaseUser != null) {
      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child('drivers');
      driversRef.child(firebaseUser.uid).once().then((driverKey) {
        final snap = driverKey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          FlutterToastr.show("Login Successfully", context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SplashScreen()));
        } else {
          FlutterToastr.show("No Record Exist With this Email.", context);
          FirebaseAuth.instance.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SplashScreen()));
        }
      });
      
    } else {
      Navigator.pop(context);
      FlutterToastr.show("Account has not been Created.", context);
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image.asset('assets/img/logo2.png', width: 170)),
              const SizedBox(height: 10),
              const Text("Email Address", style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200.withOpacity(0.8),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              const Text("Password", style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              TextFormField(
                controller: passController,
                obscureText: isObscure,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200.withOpacity(0.8),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Don't have an account?",style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
                  const SizedBox(width: 7,),
                  InkWell(onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                  },child: const Text("Create New Account",style: TextStyle(color: Color.fromARGB(255, 64, 135, 220),fontSize: 14, fontWeight: FontWeight.w700),),)
                ],
              ),

              const SizedBox(height: 10,),
              InkWell(
                onTap: () {
                  validateForm();
                },
                child: Container(
                  width: double.maxFinite,
                  height: 50,
                  decoration: BoxDecoration(
                    color: appTheme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Text("Sign In",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
