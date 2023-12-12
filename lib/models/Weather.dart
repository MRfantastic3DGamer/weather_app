class Weather{
  final String cityName;
  final double temperature;
  final String mainCondition;
  final double windSpeed;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.windSpeed,
  });

  factory Weather.fromJson(String cityName, Map<String, dynamic> json) {
    return Weather(
      cityName: cityName,
      temperature: json['list'][0]['main']['temp'],
      mainCondition: json['list'][0]['weather'][0]['description'],
      windSpeed: json['list'][0]['wind']['speed']
    );
  }
}