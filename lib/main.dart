import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'alphabets.dart'

void main() {
  runApp(TeluguAlphabetPlayer());
}

class TeluguAlphabetPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telugu Alphabet Player',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: AlphabetPlayerScreen(),
    );
  }
}

class AlphabetPlayerScreen extends StatefulWidget {
  @override
  _AlphabetPlayerScreenState createState() => _AlphabetPlayerScreenState();
}

class _AlphabetPlayerScreenState extends State<AlphabetPlayerScreen> {
  final FlutterTts flutterTts = FlutterTts();
  String currentAlphabet ='';
  bool isPlaying =false;
  int repeatCount=10;

  List<String> alphabets = Alphabets.alphabets;

  List<DropdownMenuItem<String>> getAlphabetDropdownItems() {
    return alphabets
        .map((alphabet) => DropdownMenuItem<String>(
              value: alphabet,
              child: Text(alphabet),
            ))
        .toList();
  }

  List<DropdownMenuItem<int>> getRepeatCountDropdownItems() {
    return List.generate(100, (index) {
      final count = index + 1;
      return DropdownMenuItem<int>(
        value: count,
        child: Text(count.toString()),
      );
    });
  }

  @override
  void initState() {
    super.initState();
   
    isPlaying = false;
    currentAlphabet = '';
    repeatCount = 1;
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void playAlphabets() async {
    setState(() {
      isPlaying = true;
    });

    for (int i = 0; i < repeatCount; i++) {
      for (final alphabet in Alphabets.alphabets) {
        if (!isPlaying) break;

        setState(() {
          currentAlphabet = alphabet;
        });

        await flutterTts.setLanguage('te-IN');
        await flutterTts.speak(alphabet);

        await Future.delayed(Duration(seconds: 1));
      }
    }

    setState(() {
      isPlaying = false;
      currentAlphabet = '';
    });
  }

  void pauseAlphabets() {
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Telugu Alphabet Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: alphabets.isNotEmpty ? alphabets.first : null,
              items: getAlphabetDropdownItems(),
              onChanged: (selectedAlphabet) {
                setState(() {
                  alphabets.remove(selectedAlphabet);
                  alphabets.insert(0, selectedAlphabet!);
                });
              },
            ),
            DropdownButton<String>(
              value: alphabets.isNotEmpty ? alphabets.last : null,
              items: getAlphabetDropdownItems(),
              onChanged: (selectedAlphabet) {
                setState(() {
                  alphabets.remove(selectedAlphabet);
                  alphabets.insert(0, selectedAlphabet!);
                });
              },
            ),
            DropdownButton<int>(
              value: repeatCount,
              items: getRepeatCountDropdownItems(),
              onChanged: (selectedCount) {
                setState(() {
                  repeatCount = selectedCount!;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Current Alphabet: $currentAlphabet',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isPlaying ? pauseAlphabets : playAlphabets,
                  child: Text(isPlaying ? 'Pause' : 'Play'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
