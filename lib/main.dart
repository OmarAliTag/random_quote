import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(RandomQuoteGenerator());
}

class RandomQuoteGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Quote Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuoteScreen(),
    );
  }
}

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  String _quote = "Click the button to get a new quote!";
  String _author = "";

  Future<void> _fetchQuote() async {
    final response = await http.get(Uri.parse('https://api.quotable.io/random'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _quote = data['content'];
        _author = data['author'];
      });
    } else {
      throw Exception('Failed to load quote');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Quote Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _quote,
              style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              _author.isNotEmpty ? '- $_author' : '',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _fetchQuote,
              child: Text('New Quote'),
            ),
          ],
        ),
      ),
    );
  }
}