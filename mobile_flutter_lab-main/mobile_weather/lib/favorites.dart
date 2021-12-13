import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:untitled3/weather.dart';
import 'search_page.dart';
import 'main.dart';

class FavouritePage extends StatefulWidget {

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
          leading: IconButton(
            onPressed: () => Navigator.pushNamed(context, "/"),
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
          title: const Text('Избранное')
      ),
      body: ListView.builder(
        itemCount: favourites.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: Neumorphic(
                style: NeumorphicStyle(
                  color: NeumorphicTheme.variantColor(context),
                  depth: -5,
                ),
                child: ListTile(
                  title: Text(favourites[index].city + " - " + favourites[index].country),
                  trailing: NeumorphicButton(
                    style: NeumorphicStyle(
                      color: NeumorphicTheme.accentColor(context).withOpacity(0.2),
                    ),
                    child: const Icon(Icons.close),
                    onPressed: () async {
                      if(favor == favourites[index]) {
                        th = Result("Moscow", "Russia");
                        var l = await fetchWeatherForecast("Moscow");
                        favor = l;
                      }
                      setState(()  {
                        favourites.removeWhere((element) => element == favourites[index]);
                      });
                    },
                  ),
                ),
              ),
              onTap: () async {
                var l = await fetchWeatherForecast(favourites[index].city);
                //log(l.toString(), name: "SPB");
                setState(()  {
                  th = favourites[index];
                  favor =  l;
                });
                () => Navigator.pushNamed(context, "/");
              },
            ),
          );
        },
      ),
    );
  }
}