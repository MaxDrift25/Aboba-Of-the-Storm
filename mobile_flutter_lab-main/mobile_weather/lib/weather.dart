import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
class Weather {
  //String name;
  final DateTime date;
  final double temp;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final int conditionCode;

  @override
  String toString() {
    return 'Weather{date: $date, temp: $temp, pressure: $pressure, humidity: $humidity, windSpeed: $windSpeed, conditionCode: $conditionCode}';
  }

  Weather(
      this.date, this.temp, this.pressure,
      this.humidity, this.windSpeed, this.conditionCode,
      );

  Weather.fromJson(Map<String, dynamic> json, bool isDaily)
      : date = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: true),
       temp = (isDaily ? json['temp']['day'] : json['temp']).toDouble(),
       pressure = json['pressure'],
       humidity = json['humidity'],
       windSpeed = json['wind_speed'].toDouble(),
       conditionCode = json['weather'][0]['id'];
 }

 class WeatherForecast {
  final Weather current;
  final List<Weather> hourly;
  final List<Weather> daily;

  WeatherForecast(this.current, this.hourly, this.daily);

  WeatherForecast.fromJson(Map<String, dynamic> json)
      : current = Weather.fromJson(json['current'], false),
       hourly = (json['hourly'] as List).map((w) => Weather.fromJson(w, false)).toList(),
       daily = (json['daily'] as List).map((w) => Weather.fromJson(w, true)).toList();

  @override
  String toString() {
    return 'WeatherForecast{current: $current, hourly: $hourly, daily: $daily}';
  }
}

 class _GeoPos {
  final double lat;
  final double lon;

  _GeoPos(this.lat, this.lon);
 }

 Future<_GeoPos> _directGeocode(String city) async {
   var url = Uri.https('api.openweathermap.org', '/geo/1.0/direct', {
   'appid': "f6ed45e8ff9e08469de6c1a1ad8d194c",
   'limit': '1',
   'q': city,
  });

  http.Response resp = await http.get(url);
  var json = jsonDecode(resp.body)[0];
  log(json.toString(), name: '_directGeocode');
  return _GeoPos(json['lat'].toDouble(), json['lon'].toDouble());
 }

 Future<WeatherForecast> fetchWeatherForecast(String city) async {
  var pos = await _directGeocode(city);
  var url = Uri.https('api.openweathermap.org', '/data/2.5/onecall', {
   'appid': "f6ed45e8ff9e08469de6c1a1ad8d194c",
   'lat': pos.lat.toString(),
   'lon': pos.lon.toString(),
   'lang': 'ru',
   'units': 'metric',
   'exclude': 'minutely,alerts',
  });
  http.Response resp = await http.get(url);
  var json = jsonDecode(resp.body);
  var f = WeatherForecast.fromJson(json);
  return f;
 }
