import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/Weather.dart';
import 'package:http/http.dart' as http;

class WeatherService{
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async{
    final res = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&units=metric'));

    if (res.statusCode == 200){
      return Weather.fromJson(cityName, jsonDecode(res.body));
    }
    else{
      throw Exception('failed to get weather');
    }
  }

  Future<String> getCurrentCity() async{
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);

    String? city = placemarks[0].locality;

    return city ?? "";
  }
}