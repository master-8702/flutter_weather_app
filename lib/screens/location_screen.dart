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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Icon(
                      Icons.near_me,
                      size: 30,
                      color: Colors.white,
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
                    child: Icon(
                      Icons.location_city,
                      size: 30,
                      color: Colors.white,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    Text(cityName)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    weatherMessage,
                    textAlign: TextAlign.right,
                    style: kMessageTextStyle,
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
