import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/models/Weather.dart';

import '../../view_model/weather_view_model.dart';

class WeatherCard extends StatefulWidget {

  final NetworkStatus status;
  final Weather weather;
  final bool saved;
  final Function click;
  final bool expanded;

  const WeatherCard({
    super.key,
    required this.status,
    required this.weather,
    required this.saved,
    required this.click,
    required this.expanded
  });

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  @override
  Widget build(BuildContext context) {
    switch (widget.status) {
      case NetworkStatus.gotResult:
        return
        Card(
          elevation: 10,
          child: Container(
            margin: const EdgeInsets.all(15),
            child:
            (widget.status == NetworkStatus.gotResult)?
            Column(
              children: [
                Text(widget.weather.cityName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                Lottie.asset(selectLottieFile(widget.weather.mainCondition)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text('temp: ${widget.weather.temperature}°C', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                        Text('wind speed: ${widget.weather.windSpeed}', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                      ],
                    ),
                    IconButton(
                      onPressed: () {widget.click();},
                      icon: Icon(
                        (widget.saved && widget.status == NetworkStatus.gotResult)?
                            Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                          size: 40,
                      )
                    )
                  ],
                )
              ],
            )
            : const SizedBox(height: 100,)
          ),
        );
      case NetworkStatus.networkError:
        return errorContent();

      case NetworkStatus.cityNotSelected:
        return emptyContent();
    }
  }

  Widget errorContent(){
    return
    Card(
      elevation: 10,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(15),
        child:
          const Text("Some network error occurred, please try again", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20))
        )
      );
  }

  Widget emptyContent(){
    return
    Card(
      elevation: 10,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(15),
        child:
          const Text("Select a location", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20))
        )
      );
  }

  Widget listTile(Weather weather){
    return Hero(
      tag: weather.cityName,
      child: ListTile(
        leading: Lottie.asset(selectLottieFile(widget.weather.mainCondition)),
        title: Column(
          children: [
            Text('temp: ${weather.temperature}°C'),
            Text('wind speed: ${weather.windSpeed}')
          ],
        ),
      ),
    );
  }

  selectLottieFile(String condition){
    switch (condition){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'dazzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      default:
        return 'assets/sunny.json';
    }
  }
}