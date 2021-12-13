import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:card_swiper/card_swiper.dart';
import 'page_settings.dart';
import 'main.dart';
import 'weather.dart';
class WeeklyForecastPage extends StatelessWidget {
  const WeeklyForecastPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cities = favor;

    return Scaffold(
      appBar: NeumorphicAppBar(
        title: const Text('Прогноз на неделю'),
      ),
      body: Swiper(
        itemBuilder: (BuildContext context,int index){
          return _WeatherDayCard(favor.daily[index]);
        },
        itemCount: favor.daily.length-1,
        itemWidth: 300.0,
        layout: SwiperLayout.STACK,
      ),
    );
  }
}

class _WeatherDayCard extends StatelessWidget {
  final Weather _weather;

  const _WeatherDayCard(this._weather);

  @override
  Widget build(BuildContext context) {
    const lightGradient = [
      Color.fromARGB(255, 205, 218, 245),
      Color.fromARGB(255, 160, 190, 255),
    ];
    const darkGradient = [
      Color.fromARGB(255, 35, 59, 112),
      Color.fromARGB(255, 16, 32, 66),
    ];

    var imgPath = weatherIcons[_weather.conditionCode];
    Widget img;
    if (imgPath != null) {
      img = Image(
        image: AssetImage(imgPath),
        width: 100,
        height: 100,
      );
    } else {
      img = SizedBox(
        width: 100,
        height: 100,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Center(
            child: Text(
              _weather.conditionCode.toString(),
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.light ? lightGradient : darkGradient,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _daysOfWeek[_weather.date.weekday]!,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: img,
              ),
              _WeatherParam(
                image: const AssetImage('assets/WeatherIcons/temperature.png'),
                text: formatTemp(_weather.temp),
              ),
              _WeatherParam(
                image: const AssetImage('assets/WeatherIcons/wind.png'),
                text: formatSpeed(_weather.windSpeed),
              ),
              _WeatherParam(
                image: const AssetImage('assets/WeatherIcons/humidity.png'),
                text: '${_weather.humidity}%',
              ),
              _WeatherParam(
                image: const AssetImage('assets/WeatherIcons/pressure.png'),
                text: formatPressure(_weather.pressure),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherParam extends StatelessWidget {
  final ImageProvider image;
  final String text;

  const _WeatherParam({required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    var iconTint = Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white;

    return ListTile(
      dense: true,
      minLeadingWidth: 0,
      leading: Image(image: image, width: 20, height: 20, color: iconTint),
      title: Text(
        text,
        style: const TextStyle(fontSize: 17),
      ),
    );
  }
}

const _daysOfWeek = {
  DateTime.monday: 'Понедельник',
  DateTime.tuesday: 'Вторник',
  DateTime.wednesday: 'Среда',
  DateTime.thursday: 'Четверг',
  DateTime.friday: 'Пятница',
  DateTime.saturday: 'Суббота',
  DateTime.sunday: 'Воскресенье',
};
const weatherIcons = {
  // Thunderstorm
  200: 'assets/WeatherItems/Rain_storm.png',
  201: 'assets/WeatherItems/Rain_storm.png',
  202: 'assets/WeatherItems/Rain_storm.png',
  210: 'assets/WeatherItems/thunderstorm.png',
  211: 'assets/WeatherItems/thunderstorm.png',
  212: 'assets/WeatherItems/thunderstorm.png',
  221: 'assets/WeatherItems/thunderstorm.png',
  230: 'assets/WeatherItems/thunderstorm.png',
  231: 'assets/WeatherItems/thunderstorm.png',
  232: 'assets/WeatherItems/thunderstorm.png',
  // rainy
  300: 'assets/WeatherItems/rainy.png',
  301: 'assets/WeatherItems/rainy.png',
  302: 'assets/WeatherItems/rainy.png',
  310: 'assets/WeatherItems/rainy.png',
  311: 'assets/WeatherItems/rainy.png',
  312: 'assets/WeatherItems/rainy.png',
  313: 'assets/WeatherItems/rainy.png',
  314: 'assets/WeatherItems/rainy.png',
  321: 'assets/WeatherItems/rainy.png',
  // Rain
  500: 'assets/WeatherItems/rainy.png',
  501: 'assets/WeatherItems/rainy.png',
  502: 'assets/WeatherItems/rainy.png',
  503: 'assets/WeatherItems/rainy.png',
  504: 'assets/WeatherItems/rainy.png',
  511: 'assets/WeatherItems/rainy.png',
  520: 'assets/WeatherItems/rainy.png',
  521: 'assets/WeatherItems/rainy.png',
  522: 'assets/WeatherItems/rainy.png',
  531: 'assets/WeatherItems/rainy.png',
  // Snow
  600: 'assets/WeatherItems/snowy.png',
  601: 'assets/WeatherItems/snowy.png',
  602: 'assets/WeatherItems/snowy.png',
  611: 'assets/WeatherItems/snowy.png',
  612: 'assets/WeatherItems/snowy.png',
  613: 'assets/WeatherItems/snowy.png',
  615: 'assets/WeatherItems/snowy.png',
  616: 'assets/WeatherItems/snowy.png',
  620: 'assets/WeatherItems/snowy.png',
  621: 'assets/WeatherItems/snowy.png',
  622: 'assets/WeatherItems/snowy.png',
  // Clear
  800: 'assets/WeatherItems/slight_touch_happyday.png',
  // Clouds
  801: 'assets/WeatherItems/partly_cloudy.png',
  802: 'assets/WeatherItems/cloudy.png',
  803: 'assets/WeatherItems/cloudy.png',
  804: 'assets/WeatherItems/cloudy.png',
};