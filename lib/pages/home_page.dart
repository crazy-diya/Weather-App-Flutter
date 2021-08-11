import 'dart:async';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/model/weather_api_model.dart';
import 'package:weather_app/services/api_call.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String localTime = "";
  String locationName = "";
  String locationRegion = "";
  String locationCountry = "";
  String currentTemperature = "";
  int isDay = 0;
  String conditionText = "";
  String conditionIcon = "";
  String windSpeed = "";
  String currentHumidity = "";
  String precipitation = "";
  int isRain = 0;
  String currentConditionIcon = '';
  String currentConditionText = '';

  TextEditingController cityController = TextEditingController();
  bool _validate = false;

  late Position _currentPosition;

  String _currentAddress = 'colombo';

  late bool serviceEnabled;
  late LocationPermission permission;

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    requestLocationPermision();
  }

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = "${place.locality}";
      });
      print(_currentAddress);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: currentLocationApiData,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: currentConditionText.isEmpty
              ? Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/night_star.jpg"),
                    fit: BoxFit.cover,
                  )),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: isDay == 1
                        ? AssetImage("assets/night.jpg")
                        : AssetImage("assets/cloudy.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    width: width,
                    height: height,
                    child: Column(
                      children: [
                        Align(
                          heightFactor: 2,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 10),
                            child: Center(
                              child: TextField(
                                controller: cityController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "City name",
                                  errorText: _validate
                                      ? 'Value Can\'t Be Empty'
                                      : null,
                                  labelStyle: GoogleFonts.lato(
                                      color: Colors.white, fontSize: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        cityController.text.isEmpty
                                            ? _validate = true
                                            : _validate = false;
                                      });

                                      if (_validate != true) {
                                        try {
                                          WeatherApiModel searchModel =
                                              await ApiCall().getData(
                                                      cityController.text
                                                          .toString())
                                                  as WeatherApiModel;
                                          setState(() {
                                            localTime = searchModel.localTime;
                                            locationName =
                                                searchModel.locationName;
                                            locationRegion =
                                                searchModel.locationRegion;
                                            locationCountry =
                                                searchModel.locationCountry;
                                            currentTemperature = searchModel
                                                .currentTemperature;
                                            isDay = searchModel.isDay;
                                            conditionText =
                                                searchModel.conditionText;
                                            conditionIcon =
                                                searchModel.conditionIcon;
                                            windSpeed = searchModel.windSpeed
                                                .toString();
                                            currentHumidity = searchModel
                                                .currentHumidity
                                                .toString();
                                            precipitation = searchModel
                                                .precipitation
                                                .toString();
                                            isRain = searchModel.isRain;
                                            currentConditionText = searchModel
                                                .currentConditionText;
                                            currentConditionIcon = searchModel
                                                .currentConditionIcon;
                                          });
                                          cityController.clear();
                                        } on Exception catch (exception) {
                                          print("Exception is :$exception ");
                                        } catch (error) {
                                          print("error is $error");
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text("Wrong City Name!"),
                                          ));
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Fill the Field!"),
                                        ));
                                      }
                                    },
                                  ),
                                  fillColor: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("$locationCountry",
                                    style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "$locationName",
                                  style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("$localTime",
                                    style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15))
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, bottom: 0, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$currentTemperature\u2103",
                                  style: GoogleFonts.lato(
                                      fontSize: 85,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: width * 0.4,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Image.network(
                                              "https:$currentConditionIcon",
                                              height: 30,
                                              width: 30,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "$currentConditionText",
                                              style: GoogleFonts.lato(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: width * 0.4,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Image.network(
                                              "https:$conditionIcon",
                                              height: 30,
                                              width: 30,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "$conditionText",
                                              style: GoogleFonts.lato(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 50,
                          thickness: 3,
                          endIndent: 20,
                          indent: 20,
                          color: Colors.white30,
                        ),
                        Align(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Wind",
                                      style: GoogleFonts.lato(
                                        fontSize: 15,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "$windSpeed",
                                      style: GoogleFonts.lato(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      "km/h",
                                      style: GoogleFonts.lato(
                                        fontSize: 13,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Rain",
                                      style: GoogleFonts.lato(
                                        fontSize: 15,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "$precipitation",
                                      style: GoogleFonts.lato(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      "mm",
                                      style: GoogleFonts.lato(
                                        fontSize: 13,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Humidity",
                                      style: GoogleFonts.lato(
                                        fontSize: 15,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "$currentHumidity",
                                      style: GoogleFonts.lato(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      "%",
                                      style: GoogleFonts.lato(
                                        fontSize: 13,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 50,
                          thickness: 3,
                          endIndent: 20,
                          indent: 20,
                          color: Colors.white30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }

  Future<void> currentLocationApiData() async {
    print("athulata aawa");
    setState(() {
      _currentAddress = _currentAddress;
    });
    WeatherApiModel model =
        await ApiCall().getData("$_currentAddress") as WeatherApiModel;
    setState(() {
      localTime = model.localTime;
      locationName = model.locationName;
      locationRegion = model.locationRegion;
      locationCountry = model.locationCountry;
      currentTemperature = model.currentTemperature;
      isDay = model.isDay;
      conditionText = model.conditionText;
      conditionIcon = model.conditionIcon;
      windSpeed = model.windSpeed;
      currentHumidity = model.currentHumidity;
      precipitation = model.precipitation;
      isRain = model.isRain;
      currentConditionText = model.currentConditionText;
      currentConditionIcon = model.currentConditionIcon;
    });
  }

  checkLocationPermission() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  requestLocationPermision() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      print("yes");
      permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.denied) {
        print("Have Permission");
        _getCurrentLocation();
        Future.delayed(const Duration(seconds: 5), () {
          print("Welcome!");
          setState(() {
            _currentAddress = _currentAddress;
          });
          currentLocationApiData();
        });
      } else {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.denied) {
          print('Location permissions are again access');
          _getCurrentLocation();
          Future.delayed(const Duration(seconds: 5), () {
            print("Welcome!");
            setState(() {
              _currentAddress = _currentAddress;
            });
            currentLocationApiData();
          });
        }
      }
    } else {
      print("No");
    }
  }
}
