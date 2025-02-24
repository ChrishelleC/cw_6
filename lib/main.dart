import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    // Provide the model to all widgets within the app.
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

/// Simplest possible model, with one field.
class Counter with ChangeNotifier {
  int value = 0;

  void setValue(int newValue) {
    value = newValue;
    notifyListeners();
  }

  // Get message based on the age
  String getAgeMessage() {
    if (value >= 0 && value <= 12) {
      return "You're a child!";
    } else if (value >= 13 && value <= 19) {
      return "Teenager Time!";
    } else if (value >= 20 && value <= 30) {
      return "You're a young adult!";
    } else if (value >= 31 && value <= 50) {
      return "You're an adult now!";
    } else {
      return "Golden Years!";
    }
  }

  // Get background color based on the age
  Color getBackgroundColor() {
    if (value >= 0 && value <= 12) {
      return Colors.blue.shade100;
    } else if (value >= 13 && value <= 19) {
      return Colors.green.shade100;
    } else if (value >= 20 && value <= 30) {
      return Colors.orange.shade100;
    } else if (value >= 31 && value <= 50) {
      return Colors.yellow.shade100;
    } else {
      return Colors.grey.shade300;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Age Counter'),
      ),
      body: Consumer<Counter>(
        builder: (context, counter, child) {
          return Container(
            color: counter.getBackgroundColor(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I am ${counter.value} years old',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),

                  // Slider to change age from 0 to 99
                  Slider(
                    value: counter.value.toDouble(),
                    min: 0,
                    max: 99,
                    divisions: 99,
                    label: counter.value.toString(),
                    onChanged: (double newValue) {
                      counter.setValue(newValue.toInt());
                    },
                  ),

                  const SizedBox(height: 20),

                  // Age milestone message
                  Text(
                    counter.getAgeMessage(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Progress Bar with color changes based on age range
                  LinearProgressIndicator(
                    value: counter.value / 99,
                    color: counter.getBackgroundColor(),
                    backgroundColor: Colors.grey[300],
                  ),
                  Text(
                    'Age Progression: ${counter.value}/99',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),

                  // Increment button above decrement button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: ElevatedButton(
                      onPressed: () {
                        counter.setValue(counter.value + 1);
                      },
                      child: const Text('Increment'),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Decrement button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: ElevatedButton(
                      onPressed: () {
                        counter.setValue(counter.value - 1);
                      },
                      child: const Text('Decrement'),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Reset button to set age to 0
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: ElevatedButton(
                      onPressed: () {
                        counter.setValue(0);
                      },
                      child: const Text('Reset Age'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
