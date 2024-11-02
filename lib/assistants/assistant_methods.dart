// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:uber/assistants/request_assistant.dart';
// import 'package:uber/core/global.dart';
// import 'package:uber/core/map_key.dart';
// import 'package:uber/core/models/User_Model.dart';

// class AssistantMethods {

//   static Future<String> searchAddressForGeo(Position position) async {
//     String humanReadableAddress = "";
//     String apiUrl = '';
//     var requestResponse = await RequestAssistant.recieveRequest(apiUrl);
//     if (requestResponse != "Error Occurred, Failed. No Response.") {
//       humanReadableAddress = requestResponse["results"][0]['formatted_address'];
//     }

//     return humanReadableAddress;
//   }

//   static void readCurrentOnlineUserInfo() async {
//     currentFirebaseUser = FirebaseAuth.instance.currentUser;
//     DatabaseReference userRef = FirebaseDatabase.instance
//         .ref()
//         .child('users')
//         .child(FirebaseAuth.instance.currentUser!.uid);

//     userRef.once().then((snap) {
//       if (snap.snapshot.value != null) {
//         userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
//       } 
//     });
//   }
// }