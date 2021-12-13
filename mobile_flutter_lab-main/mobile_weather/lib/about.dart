import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);
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
          title: const Text('О приложении')
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: (MediaQuery.of(context).size.width/100)*2),
          Center(
            child: Neumorphic(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              style: NeumorphicStyle(
                depth: -3,
                color: NeumorphicTheme.variantColor(context),
              ),
              child: const Text(
                'Sussus Amogus',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          const SizedBox(height: 180),
          Expanded(
            child: Neumorphic(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: const [
                      Text(
                        'by MaxDrift',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('Версия 13.37'),
                      Text('от 31 февраля 2021'),
                    ],
                  ),
                  const Text(
                    '2021',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//flexible flutter