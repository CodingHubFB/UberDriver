import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:uber_driver/mainScreens/Car_Info_Screen.dart';
import 'package:uber_driver/mainScreens/Login_Screen.dart';
import 'package:uber_driver/core/app_theme.dart';
import 'package:uber_driver/core/global.dart';
import 'package:uber_driver/core/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool isObscure = true;

  validateForm() {
    final RegExp emailExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (nameController.text.length < 3) {
      FlutterToastr.show("Name Must be at least 3 Characters. ", context);
    } else if (!emailExp.hasMatch(emailController.text)) {
      FlutterToastr.show("Email Address is Not Valid", context);
    } else if (phoneController.text.isEmpty) {
      FlutterToastr.show("Phone Number is Required", context);
    } else if (passController.text.length < 6) {
      FlutterToastr.show("Password Must be at least 6 Characters", context);
    } else {
      saveDriverInfoNow();
    }
  }

  saveDriverInfoNow() async {
    showDialog(context: context,barrierDismissible: false, builder: (context) {
      return ProgressDialog(message: "Processing, Please Wait...",);
    });
    final User? firebaseUser = (
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim()
      ).catchError((msg){
        Navigator.pop(context);
        FlutterToastr.show("Error: $msg", context);
      })
    ).user;

    if (firebaseUser != null) {
      Map driverMap = {
        "id": firebaseUser.uid,
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
      };
      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child('drivers');
      driversRef.child(firebaseUser.uid).set(driverMap);
      currentFirebaseUser = firebaseUser;
      FlutterToastr.show("Account has been Created.", context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => const CarInfoScreen()));
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Image.asset('assets/img/logo2.png', width: 170)),
                const SizedBox(height: 10),
                const Text("Name", style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200.withOpacity(0.8),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                  ),
                ),
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
                const Text("Phone", style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200.withOpacity(0.8),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10,),
                const Text("Password", style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passController,
                  obscureText: isObscure,
                  keyboardType: TextInputType.visiblePassword,
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
                    const Text("Have an account?",style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
                    const SizedBox(width: 7,),
                    InkWell(onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },child: const Text("Login",style: TextStyle(color: Color.fromARGB(255, 64, 135, 220),fontSize: 14, fontWeight: FontWeight.w700),),)
                  ],
                ),
            
                const SizedBox(height: 10,),
                Opacity(
                  opacity:  0.7,
                  child: InkWell(
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
                      child: const Text("Create New Account",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
