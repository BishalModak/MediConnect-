import 'package:flutter/cupertino.dart';
import '../Models/direction.dart';

class AppInfo extends ChangeNotifier{
  Direction? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  List<String> historyTripKeyList = [];
  //List<TripHistoryModel> allTripHistoryInformationListy = [];

  void updatePickUpLocationAddress(Direction userPickUpAddress){
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAdress(Direction dropOffAddress){
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }
}