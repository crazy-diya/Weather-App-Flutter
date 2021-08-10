class WeatherApiModel {
  String localTime;
  String locationName;
  String locationRegion;
  String locationCountry;
  String currentConditionIcon;
  String currentConditionText;
  String currentTemperature;
  int isDay;
  String conditionText;
  String conditionIcon;
  String windSpeed;
  String currentHumidity;
  String precipitation;
  int isRain;

  WeatherApiModel(
      {this.isRain = 0,
      this.precipitation = '',
      this.currentHumidity = '',
      this.localTime = '',
      this.locationName = '',
      this.locationRegion = '',
      this.locationCountry = '',
      this.currentConditionText = '',
      this.currentConditionIcon = '',
      this.currentTemperature = '',
      required this.isDay,
      this.conditionText = '',
      this.conditionIcon = '',
      this.windSpeed = ''});
}
