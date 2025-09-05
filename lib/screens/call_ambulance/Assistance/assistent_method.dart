import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mediconnect/screens/call_ambulance/Assistance/request_assistent.dart';
import 'package:provider/provider.dart';

import '../Models/direction.dart';
import '../Models/direction_details_info.dart';
import '../Models/user_model.dart';
import '../global/global.dart';
import '../global/map_key.dart';
import '../infoHandler/app_info.dart';


class AssistentMethods {
  static Future<void> readCurrentOnlineUserInfo() async {
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("user")
        .child(currentUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static Future<String> searchAddressForGeographicCoOrdinates(Position position, context) async{
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey";

    String humanReadableAddress = "";

    var requestResponse = await RequestAssistent.receiveRequest(apiUrl);

    if(requestResponse != 'Error Occured. Faild. No Response') {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Direction userPickupAddress = Direction();
      userPickupAddress.locationLatitude = position.latitude;
      userPickupAddress.locationLongitude = position.longitude;
      userPickupAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickupAddress);
    }

    return humanReadableAddress;
  }

  static Future<DirectionDetailsInfo> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async {
    String urlOriginToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=${mapkey}";
    var responseDirectionApi = await RequestAssistent.receiveRequest(urlOriginToDestinationDirectionDetails);

    // if(responseDirectionApi == "Error Occured. Failed. No Response"){
    //   return;
    // }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_point = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text = responseDirectionApi["routes"][0]["legs"][0]["overview_polyline"]["points"];
    directionDetailsInfo.distance_value = responseDirectionApi["routes"][0]["legs"][0]["overview_polyline"]["points"];

    directionDetailsInfo.duration_text = responseDirectionApi["routes"][0]["legs"][0]["overview_polyline"]["points"];
    directionDetailsInfo.duration_value = responseDirectionApi["routes"][0]["legs"][0]["overview_polyline"]["points"];

    return directionDetailsInfo;
  }

}
