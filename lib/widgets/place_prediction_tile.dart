import 'package:flutter/material.dart';
import 'package:mediconnect/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';
import '../screens/call_ambulance/Assistance/request_assistent.dart';
import '../screens/call_ambulance/Models/direction.dart';
import '../screens/call_ambulance/Models/predicted_place.dart';
import '../screens/call_ambulance/global/global.dart';
import '../screens/call_ambulance/global/map_key.dart';
import '../screens/call_ambulance/infoHandler/app_info.dart';

class PlacePredictionTileDesign extends StatefulWidget {
  final PredictedPlace? predictedPlace;
  PlacePredictionTileDesign({this.predictedPlace});

  @override
  State<PlacePredictionTileDesign> createState() =>
      _PlacePredictionTileDesignState();
}

class _PlacePredictionTileDesignState extends State<PlacePredictionTileDesign> {

  getPlaceDirectionDetails(String? placeId, context) async{
    showDialog(context: context, builder: (BuildContext context) => ProgressDialog(
      message: "Setting up Drop-off. Please wait......",
    ));

    String placeDirectionDetailsUrl = "https://maps.googleeapsis.com/maps/api/places/details/json?place_id=$placeId&key=$mapkey";

    var responseApi = await RequestAssistent.receiveRequest(placeDirectionDetailsUrl);

    Navigator.pop(context);

    if(responseApi == "Error Occured. Failed. No Response"){
      return;
    }

    if(responseApi["status"] == "OK"){
      Direction direction = Direction();
      direction.locationName = responseApi["result"]["name"];
      direction.locationId = placeId;
      direction.locationLatitude = responseApi["result"]["geometry"]["location"]["lat"];
      direction.locationLongitude = responseApi["result"]["geometry"]["location"]["lng"];

      Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAdress(direction);

      setState(() {
        userDropOffAddress = direction.locationName!;
      });

      Navigator.pop(context, "obtainedDropOff");
    }

  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return ElevatedButton(
      onPressed: () {
        getPlaceDirectionDetails(widget.predictedPlace!.place_id, context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: darkTheme ? Colors.black : Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(
              Icons.add_location,
              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
            ),

            SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.predictedPlace!.main_text!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                    ),
                  ),

                  Text(
                    widget.predictedPlace!.secondary_text!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
