import 'dart:math';

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

class HistorialItem {
  int value;
  bool acert;

  HistorialItem({required this.value, required this.acert});
}

class _MyHomePageState extends State<MyHomePage> {
  String taValue = '';
  int _numValue = 0;
  double _difficultySliderValue = 0.0;
  int _minNumber = 1;
  int _maxNumber = 10;
  int tries = 5;
  int currentTries = 5;
  int rng = Random().nextInt(10);
  String? _errorMessage;
  List<HistorialItem> historial = [];
  List<int> historialRng = [];
  List<int> menorQue = [];
  List<int> mayorQue = [];

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
              Text("Numero de intentos: $currentTries"),
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
                        _numValue = num;
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
                onEditingComplete: () {
                  setState(() {
                    if (taValue.isNotEmpty) {
                      if (_numValue != rng) {
                        if (currentTries - 1 == 0) {
                          currentTries = tries;
                          _minNumber = 1;
                          rng = Random().nextInt(5);
                          historial.insert(
                              0, HistorialItem(value: rng, acert: false));
                          mayorQue.clear();
                          menorQue.clear();
                        } else {
                          currentTries = currentTries - 1;

                          if (_numValue > rng) {
                            mayorQue.insert(0, _numValue);
                          } else if (_numValue < rng) {
                            menorQue.insert(0, _numValue);
                          }
                        }
                      } else {
                        historial.insert(
                            0, HistorialItem(value: rng, acert: true));
                        rng = 1 + Random().nextInt(_maxNumber);
                        mayorQue.clear();
                        menorQue.clear();
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
                height: 30,
              ),
              Text(difficultyLabel(_difficultySliderValue)),
              SizedBox(
                height: 45,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("menor que"),
                        Container(
                          height: 200.0,
                          width: 80.0,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2.0),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: menorQue
                                  .map((item) => Text(item.toString()))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        Text("mayor que"),
                        Container(
                          height: 200.0,
                          width: 80.0,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2.0),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: mayorQue
                                  .map((item) => Text(item.toString()))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        Text("historial"),
                        Container(
                          height: 200.0,
                          width: 80.0,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2.0),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: historial
                                  .map((item) => Text(
                                        item.value.toString(),
                                        style: TextStyle(
                                            color: item.acert
                                                ? Colors.green
                                                : Colors.red),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 45,
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
                        currentTries = tries = 5;
                        mayorQue.clear();
                        menorQue.clear();
                        break;
                      case 1.0:
                        _minNumber = 1;
                        _maxNumber = 20;
                        currentTries = tries = 8;
                        break;
                      case 2.0:
                        _minNumber = 1;
                        _maxNumber = 100;
                        mayorQue.clear();
                        menorQue.clear();
                        currentTries = tries = 15;
                        break;
                      case 3.0:
                        _minNumber = 1;
                        _maxNumber = 1000;
                        mayorQue.clear();
                        menorQue.clear();
                        currentTries = tries = 25;
                        break;
                      default:
                        _minNumber = 1;
                        _maxNumber = 10;
                        mayorQue.clear();
                        menorQue.clear();
                        currentTries = tries = 5;
                    }
                    rng = 1 + Random().nextInt(_maxNumber);
                  });
                },
              )
            ],
          ),
        )));
  }
}
