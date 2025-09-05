import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mediconnect/screens/call_ambulance/precise_pickup_location.dart';
import 'package:mediconnect/screens/call_ambulance/search_places_screen.dart';
import 'package:provider/provider.dart';

import '../../widgets/progress_dialog.dart';
import 'Assistance/assistent_method.dart';
import 'global/global.dart';
import 'infoHandler/app_info.dart';

class CallAmbulanceMainScreen extends StatefulWidget {
  const CallAmbulanceMainScreen({super.key});

  @override
  State<CallAmbulanceMainScreen> createState() =>
      _CallAmbulanceMainScreenState();
}

class _CallAmbulanceMainScreenState extends State<CallAmbulanceMainScreen> {
  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  double searchLocationContainerHeight = 220;
  double waitingResponsefromDriverContainerHeight = 0;
  double assignedDrierInfoContainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocation = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoordinationList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markerSet = {};
  Set<Circle> circlerSet = {};

  String userName = "";
  String userEmail = "";

  bool openNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

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
    print("This is our address = " + humanReadableAddress);

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    // InitialLizeGeoFireListener();
    //
    // AssistentMethods.readTripsKeyForOnlineUser(context);
  }

  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition = Provider.of<AppInfo>(
      context,
      listen: false,
    ).userPickUpLocation;
    var destinationPosition = Provider.of<AppInfo>(
      context,
      listen: false,
    ).userDropOffLocation;

    var originLatLng = LatLng(
      originPosition!.locationLatitude!,
      originPosition!.locationLongitude!,
    );
    var destinationLatLng = LatLng(
      destinationPosition!.locationLatitude!,
      destinationPosition!.locationLongitude!,
    );

    showDialog(
      context: context,
      builder: (BuildContext contex) =>
          ProgressDialog(message: "Please wait...."),
    );

    var directionDetailsinfo =
        await AssistentMethods.obtainOriginToDestinationDirectionDetails(
          originLatLng,
          destinationLatLng,
        );

    setState(() {
      tripDirectionDetailsInfo = directionDetailsinfo;
    });

    Navigator.pop(context);

    List<PointLatLng> decodePolyLinePointsResultList =
        PolylinePoints.decodePolyline(directionDetailsinfo.e_point!);

    pLineCoordinationList.clear();

    if (decodePolyLinePointsResultList.isNotEmpty) {
      decodePolyLinePointsResultList.forEach((PointLatLng pointlatlng) {
        pLineCoordinationList.add(
          LatLng(pointlatlng.latitude, pointlatlng.longitude),
        );
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.blue,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinationList,
        startCap: Cap.roundCap,
        geodesic: true,
        width: 5,
      );

      polyLineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;

    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.latitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: destinationLatLng,
        northeast: originLatLng,
      );
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng = LatLngBounds(
        southwest: originLatLng,
        northeast: destinationLatLng,
      );
    }

    newGoogleMapController!.animateCamera(
      CameraUpdate.newLatLngBounds(boundsLatLng, 65),
    );

    Marker originMarker = Marker(
      markerId: MarkerId("originID"),
      infoWindow: InfoWindow(
        title: originPosition.locationName,
        snippet: "Origin",
      ),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId("destinationID"),
      infoWindow: InfoWindow(
        title: destinationPosition.locationName,
        snippet: "Destination",
      ),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markerSet.add(originMarker);
      markerSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinatinCircle = Circle(
      circleId: CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    setState(() {
      circlerSet.add(originCircle);
      circlerSet.add(destinatinCircle);
    });
  }

  // getAddressFromLatLng() async {
  //   try {
  //     GeoData data = await Geocoder2.getDataFromCoordinates(
  //       latitude: pickLocation!.latitude,
  //       longitude: pickLocation!.longitude,
  //       googleMapApiKey: mapkey,
  //     );
  //     setState(() {
  //       Direction userPickupAddress = Direction();
  //       userPickupAddress.locationLatitude = pickLocation!.latitude;
  //       userPickupAddress.locationLongitude = pickLocation!.longitude;
  //       userPickupAddress.locationName = data.address;
  //       Provider.of<AppInfo>(
  //         context,
  //         listen: false,
  //       ).updatePickUpLocationAddress(userPickupAddress);
  //       //_address = data.address;
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(top: 30, bottom: bottomPaddingOfMap),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              initialCameraPosition: _kGooglePlex,
              polylines: polyLineSet,
              markers: markerSet,
              circles: circlerSet,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                setState(() {});
                locateUserPosition();
              },
              // onCameraMove: ((CameraPosition? position) {
              //   if (pickLocation != position!.target) {
              //     setState(() {
              //       pickLocation = position.target;
              //     });
              //   }
              // }),
              // onCameraIdle: () {
              //   getAddressFromLatLng();
              // },
            ),
            // Align(
            //   alignment: Alignment.center,
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom: 35.0),
            //     child: Image.asset("images/pick.png", height: 45, width: 45),
            //   ),
            // ),

            //ui for searching Location
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
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(height: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'From',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            Provider.of<AppInfo>(
                                                      context,
                                                    ).userPickUpLocation !=
                                                    null
                                                ? (Provider.of<AppInfo>(context)
                                                              .userPickUpLocation!
                                                              .locationName!)
                                                          .substring(0, 24) +
                                                      "..."
                                                : "Not Getting Address",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 5),

                                Divider(
                                  height: 1,
                                  thickness: 2,
                                  color: Colors.blue,
                                ),

                                SizedBox(height: 5),

                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: GestureDetector(
                                    onTap: () async {
                                      var responseFromSearchScreen =
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchPlacesScreen(),
                                            ),
                                          );

                                      if (responseFromSearchScreen ==
                                          "obtainedDropoff") {
                                        setState(() {
                                          openNavigationDrawer = false;
                                        });
                                      }

                                      await drawPolyLineFromOriginToDestination();
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'To',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                Provider.of<AppInfo>(
                                                          context,
                                                        ).userDropOffLocation !=
                                                        null
                                                    ? Provider.of<AppInfo>(
                                                                context,
                                                              )
                                                              .userDropOffLocation!
                                                              .locationName!
                                                              .substring(
                                                                0,
                                                                24,
                                                              ) +
                                                          "..."
                                                    : "Where To",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 5),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PrecisePickupLocation(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Change Pick Up",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),

                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "Call Ambulance",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Positioned(
            //   top: 40,
            //   right: 20,
            //   left: 20,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       border: Border.all(color: Colors.black),
            //       color: Colors.white,
            //     ),
            //     padding: EdgeInsets.all(20),
            //     child: Text(
            //       Provider.of<AppInfo>(context).userPickUpLocation != null
            //           ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0,24)+"..."
            //           : "Not Getting Address",
            //       overflow: TextOverflow.visible,
            //       softWrap: true,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
