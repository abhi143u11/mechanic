import 'package:flutter/material.dart';

class History extends StatefulWidget {
  static const String routeName= 'history';
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('history'),
      ),
    );
  }
}
