import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'weather.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'page_settings.dart';
import 'forecast.dart';
import 'favorites.dart';
import 'about.dart';
import 'search_page.dart';
import 'package:intl/intl.dart';




Result th = Result("Moscow", "Russia");
WeatherForecast favor =
    WeatherForecast(Weather(DateTime.now(), 0, 0, 0, 0, 0), [], []);

Future<void> main() async {
  //ServicesBinding.instance!.initInstances();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
  favor = await fetchWeatherForecast("Moscow");
  runApp(
    const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const lightPrimary = Color(0xffe2ebff);
    const darkPrimary = Color(0xff0c1620);

    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      theme: const NeumorphicThemeData(
        baseColor: lightPrimary,
        variantColor: Color(0xffe1e9ff),
        accentColor: Color(0xff4b5f88),
        appBarTheme: NeumorphicAppBarThemeData(
          color: lightPrimary,
        ),
        textTheme: TextTheme(
          subtitle1: TextStyle(color: Color(0xff656565)),
          subtitle2: TextStyle(color: Colors.white),
        ),
      ),
      darkTheme: const NeumorphicThemeData(
        baseColor: darkPrimary,
        variantColor: Color(0xff0d172b),
        accentColor: Color(0xff0a1121),
        shadowLightColor: Color(0xFF828282),
        defaultTextColor: Colors.white,
        textTheme: TextTheme(
          subtitle1: TextStyle(color: Color(0xffe5e5e5)),
          subtitle2: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      materialTheme: ThemeData(
        scaffoldBackgroundColor: lightPrimary,
        backgroundColor: lightPrimary,
        cardColor: lightPrimary,
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: lightPrimary,
        ),
      ),
      materialDarkTheme: ThemeData(
        scaffoldBackgroundColor: darkPrimary,
        primaryColor: Colors.white,
        backgroundColor: darkPrimary,
        cardColor: darkPrimary,
        brightness: Brightness.dark,
        cardTheme: const CardTheme(
          shadowColor: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
        ),
      ),
      title: 'whether',
      routes: {
        '/': (context) => const HomePage(),
        '/settings': (context) => const SettingsPage(),
        '/about': (context) => const AboutPage(),
        '/favorite': (context) => FavouritePage(),
        '/search': (context) => const CitySearchPage(),
        '/weather': (context) => const WeeklyForecastPage(),
      },
      initialRoute: '/',
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _EotsDrawer(),
      body: SlidingUpPanel(
        maxHeight: 400,
        minHeight: 225,
        collapsed: Container(
          padding: EdgeInsets.fromLTRB(0.0, 175.0, 0.0, 0.0),
          child: TextButton(
            child: Text('Прогноз на неделю'),
            onPressed: () => Navigator.pushNamed(context, "/weather"),
          ),
        ),
        padding: const EdgeInsets.all(5),
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        panel: const HourlyForecast(expanded: true),
        // collapsed: Container(
        //   color: Theme.of(context).backgroundColor,
        //   child: const HourlyForecast(expanded: false),
        // ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Theme.of(context).brightness == Brightness.light
                  ? const AssetImage('assets/background2.jpg')
                  : const AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                          builder: (context) => _ExtrudedButton(
                                child:
                                    const Icon(Icons.menu, color: Colors.white),
                                onPressed: () =>
                                    Scaffold.of(context).openDrawer(),
                              )),
                        Text(
                          th.city,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      _ExtrudedButton(
                        child: const Icon(Icons.add, color: Colors.white),
                        onPressed: () =>
                            setState(() {Navigator.pushNamed(context, '/search');})
                      ),

                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  formatTemp(favor.current.temp),
                  style: const TextStyle(fontSize: 50, color: Colors.white),
                ),
                Text(
                  '${favor.current.date.day} ${_shortMonths[favor.current.date.month]} ${favor.current.date.year}г.',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),

        ),

      ),
    );
  }
}


class _EotsDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Aboba Of The Storm',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Настройки'),
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Избранное'),
                onTap: () => Navigator.pushNamed(context, '/favorite'),
              ),
              ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('О приложении'),
                  onTap: () => Navigator.pushNamed(context, '/about')
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExtrudedButton extends StatelessWidget {
  final Widget child;
  final NeumorphicButtonClickListener onPressed;

  const _ExtrudedButton({required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: const NeumorphicStyle(
        color: Colors.transparent,
        lightSource: LightSource(0, 0),
        shadowLightColor: Colors.black87,
        boxShape: NeumorphicBoxShape.circle(),
      ),
      child: child,
      onPressed: onPressed,
    );
  }
}
class HourlyForecast extends StatelessWidget {
  final bool _expanded;

  const HourlyForecast({required bool expanded, Key? key})
      : _expanded = expanded,
        super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          height: 5,
          width: 50,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 20),
        _buildExpanded(context),
      ],
    );
  }
}

Widget _buildExpanded(BuildContext context) {

  return Column(
    children: [
      Text(
        '${favor.current.date.day} ${_months[favor.current.date.month]}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _WeatherCard(favor.hourly[0]),
          _WeatherCard(favor.hourly[6]),
          _WeatherCard(favor.hourly[12]),
          _WeatherCard(favor.hourly[18]),
        ],
      ),
      const SizedBox(height: 50),
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        padding: const EdgeInsets.all(8),
        children: [
          _WeatherParamCard(
            const AssetImage('assets/WeatherIcons/temperature.png'),
            formatTemp(favor.current.temp),
          ),
          _WeatherParamCard(
            const AssetImage('assets/WeatherIcons/humidity.png'),
            '${favor.current.humidity}%',
          ),
          _WeatherParamCard(
            const AssetImage('assets/WeatherIcons/wind.png'),
            formatSpeed(favor.current.windSpeed),
          ),
          _WeatherParamCard(
            const AssetImage('assets/WeatherIcons/pressure.png'),
            formatPressure(favor.current.pressure),
          ),
        ],
      ),
    ],
  );
}

class _WeatherParamCard extends StatelessWidget {
  final ImageProvider image;
  final String text;

  const _WeatherParamCard(this.image, this.text);

  @override
  Widget build(BuildContext context) {
    var iconTint = Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white;

    return Card(
      elevation: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: image, color: iconTint, width: 20, height: 20),
          const SizedBox(width: 5),
          Text(text),
        ],
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final Weather _weather;

  const _WeatherCard(this._weather);

  @override
  Widget build(BuildContext context) {
    var imgPath = weatherIcons[_weather.conditionCode];
    Widget img;
    if (imgPath != null) {
      img = Image(
        image: AssetImage(imgPath),
        width: 50,
        height: 50,
      );
    } else {
      img = SizedBox(
        width: 50,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Center(
            child: Text(_weather.conditionCode.toString()),
          ),
        ),
      );
    }

    return Neumorphic(
      // elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          children: [
            Text(DateFormat('HH:mm').format(_weather.date)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: img,
            ),
            Text(formatTemp(_weather.temp)),
          ],
        ),
      ),
    );
  }
}

const _months = {
  DateTime.january: 'января',
  DateTime.february: 'февраля',
  DateTime.march: 'марта',
  DateTime.april: 'апреля',
  DateTime.may: 'мая',
  DateTime.june: 'июня',
  DateTime.july: 'июля',
  DateTime.august: 'августа',
  DateTime.september: 'сентября',
  DateTime.october: 'октября',
  DateTime.november: 'ноября',
  DateTime.december: 'декабря',
};

const _shortMonths = {
  DateTime.january: 'янв.',
  DateTime.february: 'февр.',
  DateTime.march: 'марта',
  DateTime.april: 'апр.',
  DateTime.may: 'мая',
  DateTime.june: 'июня',
  DateTime.july: 'июля',
  DateTime.august: 'авг.',
  DateTime.september: 'сент.',
  DateTime.october: 'окт.',
  DateTime.november: 'ноября',
  DateTime.december: 'дек.',
};