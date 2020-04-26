import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mechanic/models/mechanic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mechanic/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class Auth with ChangeNotifier {
  String _userId;
  String _name;
  String _mobile;
  String _email;
  String _errormsg;
  double _longitude;
  double _latitude;

  String get name => _name;
  String get email => _email;
  String get mobile => _mobile;
  String get errorMsg => _errormsg;
  bool get isAuth => _userId != null;
  String get userId => _userId;
  double get latitude => _latitude;
  double get longitude => _longitude;

  Future<Position> getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _latitude = position.latitude;
    _longitude = position.longitude;
    return position;
  }

  Future<void> updateLocation() async {
    try {
      final response = await http.post(
        "$BASE_URL/mecha/updateuser/$_userId",
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "latitude": latitude !=null ? _latitude : 28.669155,
            "longitude": longitude !=null ? longitude : 77.453758,
          },
        ),
      );
      if (response.statusCode == 200) {
      } else {
        print(response.body);
        print(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    print("$email and $password");
    try {
      final response = await http.post("$BASE_URL/login",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json
              .encode({"email": email, "password": password, "type": "mecha"}));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _userId = data[0]['_id'];
        _name = data[0]['name'];
        _email = data[0]['email'];
        print("login $_userId");
        print(response.body);
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {'userId': _userId, 'name': _name, 'email': _email},
        );
        prefs.setString('userData', userData);
        notifyListeners();
      } else {
        print(response.statusCode);
        print(response.body);
        _errormsg = jsonDecode(response.body);
        notifyListeners();
        print(_errormsg);
      }
    } catch (e) {
      print(e);
      print('error');
      throw e;
    }
    notifyListeners();
  }

  Future<void> signup(Mechanic mechanic) async {
    print("mob ${mechanic.mobileno}");
    try {
      final response = await http.post("$BASE_URL/mecha/newuser",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "name": mechanic.name,
            "email": mechanic.email,
            "address": mechanic.address,
            "password": mechanic.password,
            "mobileno": mechanic.mobileno,
            "car": mechanic.car ? 1 : 0,
            "bus": mechanic.bus ? 1 : 0,
            "toe": mechanic.toe ? 1 : 0,
            "bike": mechanic.bike ? 1 : 0,
            "truck": mechanic.truck ? 1 : 0,
            "tacter": mechanic.tacter ? 1 : 0,
            "autoer": mechanic.autoer ? 1 : 0,
            "organisatio": mechanic.org,
            "latitude": latitude !=null ? _latitude : 28.669155,
            "longitude": longitude !=null ? longitude : 77.453758,
          }));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _userId = data['_id'];
        _name = data['name'];
        _email = data['email'];
//        _mobile = data['mobileno'];
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {'userId': _userId, 'name': _name, 'email': _email},
        );
        prefs.setString('userData', userData);
        notifyListeners();
      } else {
        print(response.body);
        print(response.statusCode);
        _errormsg = jsonDecode(response.body)['errmsg'];
      }
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    print("log out $userId");
    try {
      final response = await http.post("$BASE_URL/logout",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({"_id": _userId}));
      print(response.body);
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
        print(response.body);
        _userId = null;
        notifyListeners();
      } else {
        print(response.statusCode);
        _errormsg = jsonDecode(response.body);
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    _userId = extractedUserData['userId'];
    _name = extractedUserData['name'];
    _email = extractedUserData['email'];
    notifyListeners();
    return true;
  }
}
