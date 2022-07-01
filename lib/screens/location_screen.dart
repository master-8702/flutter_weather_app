import 'package:clima/screens/cityy_screen.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.weatherData});

  final weatherData;
  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  int temprature = 0;
  String weatherIcon = "";
  String cityName = "";
  String weatherMessage = "";

  @override
  void initState() {
    super.initState();

    updateUI(widget.weatherData);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      double temp = weatherData['main']['temp'];
      temprature = temp.toInt();
      weatherMessage = weatherModel.getMessage(temprature);
      var conditionWeatherId = weatherData['weather'][0]['id'];
      cityName = weatherData['name'];
      weatherIcon = weatherModel.getWeatherIcon(conditionWeatherId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'images/location_background4.jpg',
            ),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Column(
                      children: const [
                        Icon(
                          Icons.near_me,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "Here",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      WeatherModel weatherModel2 = WeatherModel();
                      var weatherData =
                          await weatherModel2.getLocationWeather();
                      print("from location weather");
                      print(weatherData);
                      updateUI(weatherData);
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(),
                    child: Column(
                      children: const [
                        Icon(
                          Icons.location_city,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "Search",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      var cityName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );
                      print(cityName);
                      if (cityName != null) {
                        var weatherData =
                            await weatherModel.getCityWeather(cityName);
                        print("from city  weather");
                        print(weatherData);
                        updateUI(weatherData);
                      }
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          (temprature.toString() + "°C"),
                          style: kTempTextStyle,
                        ),
                        Text(
                          weatherIcon,
                          style: kConditionTextStyle,
                        ),
                      ],
                    ),
                    Text(
                      cityName,
                      style: (TextStyle(
                        fontSize: 20,
                      )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      weatherMessage,
                      textAlign: TextAlign.right,
                      style: kMessageTextStyle,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
