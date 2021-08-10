import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_api_model.dart';

class ApiCall {
  getData(String locationName) async {
    var url = Uri.parse(
        "https://api.weatherapi.com/v1/forecast.json?key=0a5f50687b4145ed9aa172022212507&q=$locationName&days=1&aqi=no&alerts=yes");
    var request = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (request.statusCode == 200) {
      var jsonData = jsonDecode(request.body);

      WeatherApiModel weatherApiModel = WeatherApiModel(
        isDay: jsonData['current']['is_day'],
        localTime: jsonData['location']['localtime'],
        locationCountry: jsonData['location']['country'],
        locationRegion: jsonData['location']['region'],
        locationName: jsonData['location']['name'],
        conditionText: jsonData['forecast']['forecastday'][0]['day']
            ['condition']['text'],
        conditionIcon: jsonData['forecast']['forecastday'][0]['day']
            ['condition']['icon'],
        currentHumidity: jsonData['forecast']['forecastday'][0]['day']
                ['avghumidity']
            .toString(),
        windSpeed: jsonData['forecast']['forecastday'][0]['day']['maxwind_kph']
            .toString(),
        currentTemperature: jsonData['forecast']['forecastday'][0]['day']
                ['avgtemp_c']
            .toString(),
        precipitation: jsonData['forecast']['forecastday'][0]['day']
                ['totalprecip_mm']
            .toString(),
        isRain: jsonData['forecast']['forecastday'][0]['day']
            ['daily_will_it_rain'],
        currentConditionIcon: jsonData['current']['condition']['icon'],
        currentConditionText: jsonData['current']['condition']['text'],
      );

      print(jsonData['forecast']['forecastday'][0]['day']['avgtemp_c']);

      // print("${weatherApiModel.locationName} \n"
      //     "${weatherApiModel.conditionText} \n"
      //     "${weatherApiModel.isDay} \n"
      //     "${weatherApiModel.conditionIcon} \n"
      //     "${weatherApiModel.currentTemperature} \n"
      //     "${weatherApiModel.localTime} \n"
      //     "${weatherApiModel.locationCountry} \n"
      //     "${weatherApiModel.locationRegion} \n"
      //     "${weatherApiModel.windSpeed} \n");
      return weatherApiModel;
    }
    else {
      print("${request.statusCode}");
      return null;
    }
  }
}
