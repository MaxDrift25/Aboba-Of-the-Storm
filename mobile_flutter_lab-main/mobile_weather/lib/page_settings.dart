import 'package:flutter_neumorphic/flutter_neumorphic.dart';

// var aboba = {
//   "temp" : true,
//   "pressure" : true,
//   "wind" : true
// };

// var _list = aboba.values.toList();

var list = [false, false, false];

String formatTemp(double temperatureC) {
  if (list[0]) {
    return '${(temperatureC * 9 / 5 + 32).round()}˚F';
  } else {
    return '${temperatureC.round()}˚C';
  }
}

String formatSpeed(double speedMs) {
  if (list[1]) {
    return '${(speedMs * 3.6).round()} к/ч';
  } else {
    return '$speedMs м/с';
  }
}

String formatPressure(int pressureHPa) {
  if (list[2]) {
    return '$pressureHPa гПа';
  } else {
    return '${(pressureHPa / 1.333).round()} мм.рт.ст.';
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    //var settings = context.watch<SettingsModel>();

    return Scaffold(
      appBar: NeumorphicAppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, "/"),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        title: const Text('Настройки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Единицы измерения',
              style: NeumorphicTheme.currentTheme(context).textTheme.subtitle1!,
            ),
            const SizedBox(height: 20),
            Neumorphic(
              style: NeumorphicStyle(
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(30)),
              ),
              child: Column(
                children: [
                  _Params(
                    title: 'Температура',
                    a: '°C',
                    b: '°F',
                    selectedIndex: list[0] ? 1 : 0,
                    onChanged: (index) {
                      setState(() {
                        list[0] = !list[0];
                      });
                    },
                  ),
                  //1 выкл 0вкыл
                  const Divider(),
                  _Params(
                    title: 'Сила ветра',
                    a: 'м/c',
                    b: 'км/ч',
                    selectedIndex: list[1] ? 1 : 0,
                    onChanged: (index) {
                      setState(() {
                        list[1] = !list[1];
                      });
                    },
                  ),
                  const Divider(),
                  _Params(
                    title: 'Давление',
                    a: 'мм.рт.ст.',
                    b: 'гПа',
                    selectedIndex: list[2] ? 1 : 0,
                    onChanged: (index) {
                      setState(() {
                        list[2] = !list[2];
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Params extends StatelessWidget {
  final String title;
  final String a;
  final String b;
  final int selectedIndex;
  final Function(int) onChanged;

  const _Params({
    required this.title,
    required this.a,
    required this.b,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: NeumorphicToggle(
        height: 25,
        width: 130,
        selectedIndex: selectedIndex,
        thumb: Neumorphic(),
        onChanged: onChanged,
        children: [
          ToggleElement(
            background: Center(child: Text(a)),
            foreground: Neumorphic(
              style: NeumorphicStyle(
                color: NeumorphicTheme.accentColor(context),
              ),
              child: Center(
                child: Text(
                  a,
                  style:
                      NeumorphicTheme.currentTheme(context).textTheme.subtitle2,
                ),
              ),
            ),
          ),
          ToggleElement(
            background: Center(child: Text(b)),
            foreground: Neumorphic(
              style: NeumorphicStyle(
                color: NeumorphicTheme.accentColor(context),
              ),
              child: Center(
                child: Text(
                  b,
                  style:
                      NeumorphicTheme.currentTheme(context).textTheme.subtitle2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
