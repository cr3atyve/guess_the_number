import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String name = 'Guess The Number';
    return MaterialApp(
      title: name,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.lightBlue[900],
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int numberOfTries = 0;
  int numberOfTimes = 5;

  // ignore: always_specify_types
  final guessedNumber = TextEditingController();

  static Random ran = Random();
  int randomNumber = ran.nextInt(99) + 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Guess The Number'),
          backgroundColor: Colors.amber,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                    'https://thumbs.dreamstime.com/b/design-squid-game-vinnytsia-ukraine-october-honeycomb-round-dalgona-sugar-honeycombs-green-circle-red-triangle-yellow-star-blue-231848906.jpg'),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'I\'m thinking of a number between 1 and 100. You only have 5 tries.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.amber),
                  ),
                ),
              ),
              const Align(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Can you guess it?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0, color: Colors.amber),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Please enter a number',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: guessedNumber),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.amber),
                  ),
                  onPressed: guess,
                  child: const Text(
                    'Guess',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void guess() {
    final invokeMethod = SystemChannels.textInput.invokeMethod<String>('TextInput.hide');

    if (isEmpty()) {
      makeToast('You did not enter a number');
      return;
    }

    final int guess = int.parse(guessedNumber.text);

    if (guess > 100 || guess < 1) {
      makeToast('Choose number between 1 and 100');
      guessedNumber.clear();
      return;
    }

    numberOfTries++;
    if (numberOfTries == numberOfTimes && guess != randomNumber) {
      makeToast('Game Over! Your Number of Tries is: $numberOfTries My number is: $randomNumber');
      numberOfTries = 0;
      randomNumber = ran.nextInt(20) + 1;
      guessedNumber.clear();
      return;
    }
    

    if (guess > randomNumber) {
      makeToast('Lower! Number of Tries is: $numberOfTries');
    } else if (guess < randomNumber) {
      makeToast('Higher! Number of Tries is: $numberOfTries');
    } else {
      makeToast("That's right. You Win! Number of Tries is: $numberOfTries");
      numberOfTries = 0;
      randomNumber = ran.nextInt(20) + 1;
    }
    guessedNumber.clear();
  }

  void makeToast(String feedback) {
    Fluttertoast.showToast(
        msg: feedback,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        fontSize: 14,
        backgroundColor: Colors.amber,
        textColor: Colors.black);
  }

  bool isEmpty() {
    return guessedNumber.text.isEmpty;
  }
}
