import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  static const String routeName= 'setting';

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
    );
  }
}
