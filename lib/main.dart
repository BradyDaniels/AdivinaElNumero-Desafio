import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adivina el numero',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 71, 95, 202)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Adivina el numero'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String taValue = '';
  double _difficultySliderValue = 0;
  int _minNumber = 1;
  int _maxNumber = 10;
  int tries = 5;

  String difficultyLabel(double value) {
    switch (value.round()) {
      case 0:
        return "Facil";
        break;
      case 1:
        return "Normal";
        break;
      case 2:
        return "Dificil";
        break;
      case 3:
        return "Avanzado";
        break;
      default:
        return "Facil";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
            child: Container(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (value) {
                  setState(() {
                    taValue = value;
                  });
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Ingresa el numero"),
              ),
              SizedBox(
                height: 40,
              ),
              Text(difficultyLabel(_difficultySliderValue)),
              SizedBox(
                height: 5,
              ),
              Slider(
                value: _difficultySliderValue,
                max: 3,
                divisions: 3,
                label: difficultyLabel(_difficultySliderValue),
                onChanged: (double value) {
                  setState(() {
                    _difficultySliderValue = value;
                  });
                },
              )
            ],
          ),
        )));
  }
}
