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
  double _difficultySliderValue = 0.0;
  int _minNumber = 1;
  int _maxNumber = 10;
  int tries = 5;
  String? _errorMessage;

  String difficultyLabel(double value) {
    switch (value) {
      case 0.0:
        return "Facil";
      case 1.0:
        return "Medio";
      case 2.0:
        return "Avanzado";
      case 3.0:
        return "Extremo";
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
              Text("Numero de intentos: $tries"),
              SizedBox(
                height: 30,
              ),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (value) {
                  setState(() {
                    taValue = value;
                    _errorMessage = null;
                    if (value.isNotEmpty) {
                      final int? num = int.tryParse(value);
                      if (num != null) {
                        if (num < _minNumber || num > _maxNumber) {
                          _errorMessage =
                              "El numero a ingresar debe estar entre $_minNumber y $_maxNumber";
                        }
                      } else {
                        _errorMessage = "Por favor, ingresa un numero valido";
                      }
                    }
                  });
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Ingresa el numero",
                    errorText: _errorMessage),
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
                    switch (value) {
                      case 0.0:
                        _minNumber = 1;
                        _maxNumber = 10;
                        tries = 5;
                        break;
                      case 1.0:
                        _minNumber = 1;
                        _maxNumber = 20;
                        tries = 8;
                        break;
                      case 2.0:
                        _minNumber = 1;
                        _maxNumber = 100;
                        tries = 15;
                        break;
                      case 3.0:
                        _minNumber = 1;
                        _maxNumber = 1000;
                        tries = 25;
                        break;
                      default:
                        _minNumber = 1;
                        _maxNumber = 10;
                        tries = 5;
                    }
                  });
                },
              )
            ],
          ),
        )));
  }
}
