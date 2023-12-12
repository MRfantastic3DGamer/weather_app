import 'package:flutter/material.dart';
import 'package:weather/pages/components/weather_card.dart';
import 'package:weather/view_model/weather_view_model.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  final TextEditingController _typeAheadController = TextEditingController(text: "select a location");

  @override
  void initState(){
    super.initState();
    // var keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe to changes
    // keyboardVisibilityController.onChange.listen((bool visible) {
    //   if (visible && _typeAheadController.text.isEmpty) {
    //     FocusScope.of(context).requestFocus(_focus);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Consumer<WeatherViewModel>(
          builder: (context, value, child) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  WeatherCard(
                    expanded: true,
                    status: value.status,
                    weather: value.weather,
                    saved: value.isSavedCity(value.selectedCity),
                    click: () {
                      {
                        if (value.isSavedCity(value.selectedCity)){
                          value.removeCity(value.selectedCity);
                        }
                        else{
                          value.addCity(value.selectedCity);
                        }
                      }
                    }
                  ),
                  const SizedBox(height: 50),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child:
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: TypeAheadField(
                                controller: _typeAheadController,
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: ListTile(title: Text(suggestion), leading: const Icon(Icons.location_pin))
                                  );
                                }, onSelected : (suggestion) {
                                  setState(() {
                                    _typeAheadController.text = suggestion;
                                  });
                                  value.fetchWeather(suggestion);
                                },
                                suggestionsCallback: (pattern) {
                                  return value.cities
                                      .where((city) => city.toLowerCase().contains(pattern.toLowerCase()))
                                      .toList();
                                },
                                hideOnEmpty: false,
                                hideOnSelect: true,
                                hideOnError: false,
                                hideWithKeyboard: false,
                                hideOnLoading: false,
                                hideOnUnfocus: false,
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child:
                                DropdownButton(
                                  disabledHint: const SizedBox(height: 0, width: 0),
                                  onChanged: (ch) {
                                    setState(() {
                                      _typeAheadController.text = ch ?? "Unknown";
                                    });
                                    value.fetchWeather(ch ?? "Unknown");
                                  },
                                  items: value.savedCities.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                )
                            ),
                            IconButton(
                              onPressed: () {
                                value.getCurrentLocation();
                                _typeAheadController.text = value.selectedCity;
                              },
                              icon: const Icon(Icons.location_searching_rounded)
                            ),
                          ],
                        ),
                      )
                  ),
                  const SizedBox(height: 200)
                ]
              ),
            );
          }
        )
      )
    );
  }
}