// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:english_words/english_words.dart'; //importing file from pubsec.yaml file
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


///Stateless widgets has to do with the superficial looks 
///For example, words, theme of the app
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     final wordPair = WordPair.random(); 
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      )),
      home: const RandomWords(),
    );
  }
}


///Stateful widgets handles the different widgets and their physical layout in the app
///From padding, to alignment and even font
class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (context) {
      final tiles = _saved.map(
        (pair) {
          return ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        },
      );
      final divided = tiles.isNotEmpty
          ? ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList()
          : <Widget>[];

      return Scaffold(
        appBar: AppBar(
          title: const Text('Saved Suggestions'),
        ),
        body: ListView(children: divided),
      );
    },
    ),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /* 1 */ (context, i) {
          if (i.isOdd) return const Divider(); /* 2 */

          final index = i ~/ 2; /* 3 */
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /* 4 */
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /* final wordPair = WordPair.random();
    return Text(wordPair.asPascalCase); */

    return Scaffold(
      appBar: AppBar(title: const Text('Startup Name Generator'), actions: [
        IconButton(
          icon: const Icon(Icons.list),
          onPressed: _pushSaved,
          tooltip: 'Saved Suggestions',
        ),
      ]),
      body: _buildSuggestions(),
    );
  }
}
