import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:uber_driver/Screens/Splash_Screen.dart';
import 'package:uber_driver/core/app_theme.dart';
import 'package:uber_driver/core/global.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({super.key});

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carModelController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();
  TextEditingController carColorController = TextEditingController();

  List<String> carTypesList = ["uber-x", "uber-go", "bike"];
  String? selectedCarType;

  saveCarInfo() {
    Map driverCarInfoMap = {
      "car_color": carColorController.text.trim(),
      "car_number": carNumberController.text.trim(),
      "car_model": carModelController.text.trim(),
      "type": selectedCarType
    };

    DatabaseReference driversRef = FirebaseDatabase.instance.ref().child('drivers');
    driversRef.child(currentFirebaseUser!.uid).child("car_details").set(driverCarInfoMap);
    FlutterToastr.show("Car Details has been Saved Congratulations.", context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SplashScreen()));
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
                const Text("Car Model", style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: carModelController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200.withOpacity(0.8),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Car Number", style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: carNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200.withOpacity(0.8),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Car Color", style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: carColorController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200.withOpacity(0.8),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10,),
                const Text("Car Type", style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 10,),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200.withOpacity(0.8),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                  ),
                  key: const Key('dropdown'),
                  hint: const Text('Select an option'),
                  value: selectedCarType,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCarType = newValue;
                    });
                  },
                  items: carTypesList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10,),
                Opacity(
                  opacity:  0.7,
                  child: InkWell(
                    onTap: () {
                       if (carColorController.text.isNotEmpty && carModelController.text.isNotEmpty && carNumberController.text.isNotEmpty && selectedCarType != null) {
                        saveCarInfo();
                       }
                    },
                    child: Container(
                      width: double.maxFinite,
                      height: 50,
                      decoration: BoxDecoration(
                        color: appTheme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text("Save Now",
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
