import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';

import 'Assistance/assistent_method.dart';
import 'Models/direction.dart';
import 'global/map_key.dart';
import 'infoHandler/app_info.dart';

class PrecisePickupLocation extends StatefulWidget {
  const PrecisePickupLocation({super.key});

  @override
  State<PrecisePickupLocation> createState() => _PrecisePickupLocationState();
}

class _PrecisePickupLocationState extends State<PrecisePickupLocation> {

  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  Position? userCurrentPosition;
  double bottomPaddingOfMap = 0;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(
      userCurrentPosition!.latitude,
      userCurrentPosition!.longitude,
    );
    CameraPosition cameraPosition = CameraPosition(
      target: latLngPosition,
      zoom: 15,
    );

    newGoogleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );

    String humanReadableAddress =
    await AssistentMethods.searchAddressForGeographicCoOrdinates(
      userCurrentPosition!,
      context,
    );
  }

  getAddressFromLatLng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: pickLocation!.latitude,
        longitude: pickLocation!.longitude,
        googleMapApiKey: mapkey,
      );
      setState(() {
        Direction userPickupAddress = Direction();
        userPickupAddress.locationLatitude = pickLocation!.latitude;
        userPickupAddress.locationLongitude = pickLocation!.longitude;
        userPickupAddress.locationName = data.address;
        Provider.of<AppInfo>(
          context,
          listen: false,
        ).updatePickUpLocationAddress(userPickupAddress);
        //_address = data.address;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(top: 30, bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {});
              locateUserPosition();
            },
            onCameraMove: ((CameraPosition? position) {
              if (pickLocation != position!.target) {
                setState(() {
                  pickLocation = position.target;
                });
              }
            }),
            onCameraIdle: () {
              getAddressFromLatLng();
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: Image.asset("images/pick.png", height: 45, width: 45),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: SafeArea(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),

          Positioned(
            top: 40,
            right: 20,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(20),
              child: Text(
                Provider.of<AppInfo>(context).userPickUpLocation != null
                    ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0,24)+"..."
                    : "Not Getting Address",
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
