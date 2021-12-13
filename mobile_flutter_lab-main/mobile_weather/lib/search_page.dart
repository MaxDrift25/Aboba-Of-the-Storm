import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'weather.dart';

List<Result> favourites = [];
class CitySearchPage extends StatefulWidget {
  const CitySearchPage({Key? key}) : super(key: key);

  @override
  _DataFromAPI createState() => _DataFromAPI();
}

class _DataFromAPI extends State<CitySearchPage> {
  final _searchFocus = FocusNode();
  final _searchController = TextEditingController();
  List<Result> list = [];

  void _fetchCities() async {
    if (_searchController.text.isEmpty) {
      return;
    }
    var l = await getUserData(_searchController.text);
    setState(() {
      list = l;
    });
  }

  Future getUserData(String query) async {
    var resp = await http.get(Uri.parse(
        "http://api.geonames.org/searchJSON?q=$query&maxRows=10&username=ton123"));
    var body = jsonDecode(resp.body);

    return (body['geonames'] as List)
        .where((geoname) => geoname['countryName'] != null)
        .map((geoname) => Result(geoname['name'], geoname['countryName']))
        .toSet()
        .toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        leading: IconButton(
          onPressed: () async {
            var l = await fetchWeatherForecast(favourites.last.city);
            setState(()  {
              th = favourites.last;
              favor =  l;
            });
            Navigator.pushNamed(context, "/");
            },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        title: TextField(
          focusNode: _searchFocus,
          controller: _searchController,
          style: const TextStyle(fontSize: 20),
          decoration: const InputDecoration(
            hintText: 'Введите город',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _fetchCities,
          ),
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: ListTile(
                title: Text('${list[index].city} - ${list[index].country}'),
                trailing: Icon(favourites.contains(list[index]) ? Icons.star : Icons.star_border),
            ),
            onTap: () {
              if (favourites.contains(list[index])) {
                favourites.removeWhere((e) => e == list[index]);
              } else {
                favourites.add(list[index]);
              }
              setState(() {});
            },
          );
        },
      ),
    );
  }
}

class Result {
  String city, country;
  Result(this.city, this.country);

  @override
  String toString() {
    return 'Result{city: $city, country: $country}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Result &&
          runtimeType == other.runtimeType &&
          city == other.city &&
          country == other.country;

  @override
  int get hashCode => city.hashCode ^ country.hashCode;


}