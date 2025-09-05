import 'package:flutter/material.dart';
import '../../widgets/place_prediction_tile.dart';
import 'Assistance/request_assistent.dart';
import 'Models/predicted_place.dart';
import 'global/map_key.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({super.key});

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  List<PredictedPlace> placesPredictedList = [];

  findPlaceAutoCompleteSearch(String inputText) async {
    if(inputText.length > 1){
      // FIXED: Corrected URL and added missing comma
      String urlAutoCompleteSearch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapkey&components=country:BD";

      var responseAutoCompleteSearch = await RequestAssistent.receiveRequest(urlAutoCompleteSearch);

      if(responseAutoCompleteSearch == "Error Occured. Failed. No Response"){
        return;
      }
      if(responseAutoCompleteSearch["status"] == "OK"){
        var placePredictions = responseAutoCompleteSearch["predictions"];

        var placePredictionsList = (placePredictions as List).map((jsonData) => PredictedPlace.fromJson(jsonData)).toList();

        setState(() {
          placesPredictedList = placePredictionsList;
        });
      }
    }
  }

  // ADD THIS METHOD TO HANDLE PLACE SELECTION
  void onPlaceSelected(PredictedPlace place) {
    // Here you would typically get more details about the place
    // For now, just return to previous screen with success message
    Navigator.pop(context, "obtainedDropoff");
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: darkTheme ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: darkTheme ? Colors.amber.shade400 : Colors.blue,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, "cancelled"); // Return cancellation message
            },
            child: Icon(
              Icons.arrow_back,
              color: darkTheme ? Colors.black : Colors.white,
            ),
          ),
          title: Text(
            "Search & dropoff location",
            style: TextStyle(color: darkTheme ? Colors.black : Colors.white),
          ),
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white54,
                    blurRadius: 8,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.adjust_sharp,
                          color: darkTheme ? Colors.black : Colors.white,
                        ),
                        SizedBox(width: 18), // FIXED: Changed height to width
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              onChanged: (value) {
                                findPlaceAutoCompleteSearch(value);
                              },
                              decoration: InputDecoration(
                                hintText: "Search location here...",
                                fillColor: darkTheme ? Colors.black : Colors.white54,
                                filled: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  left: 11,
                                  top: 8,
                                  bottom: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            //display place predictions result
            (placesPredictedList.length > 0)
                ? Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      onPlaceSelected(placesPredictedList[index]);
                    },
                    child: PlacePredictionTileDesign(
                      predictedPlace: placesPredictedList[index],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    height: 0,
                    color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                  );
                },
                itemCount: placesPredictedList.length,
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}