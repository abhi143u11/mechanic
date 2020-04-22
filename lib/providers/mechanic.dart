import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mechanic/constants.dart';

class Mechanic with ChangeNotifier {
  String _name;
  String _custId;
  String _historyId;
  double _latitude;
  double _longitude;
  String _type;
  double _distance;
  double _time;
  bool _indicator = false;
  bool _isCancel = false;
  bool _isDone = false;

  bool get isCancel {
    return _isCancel;
  }

  bool get isDone {
    return _isDone;
  }

  final String _userId;
  Mechanic(this._userId);

  bool get indicator {
    return _indicator;
  }

  String get name {
    return _name;
  }

  double get distance {
    return _distance;
  }

  double get time {
    return _time;
  }

  Future<void> checkPoint(String userId) async {
    print(_userId);
    print("mechId $userId");
    try {
      final response = await http.post("$BASE_URL/mecha/checkpoint",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({"_id": _userId})); //userId
      if (response.statusCode == 200) {
        print(response.body);
        final jsonData = jsonDecode(response.body);
        print(jsonData[0][0]);
        if (jsonData[0][0] == 0) {
          _indicator = false;
          notifyListeners();
        } else {
          _name = jsonData[1];
          _indicator = true;
          _latitude = jsonData[0][1];
          _longitude = jsonData[0][2];
          _custId = jsonData[0][3];
          _type = jsonData[0][4];
          _historyId = jsonData[0][5];
          _distance = jsonData[0][6];
          _time = jsonData[0][7];
          print("customer check point");
          notifyListeners();
        }
      } else {
        print(response.body);
        print(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> mechaReach() async {
    print(_userId);
    try {
      final response = await http.post("$BASE_URL/mecha/reach",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "_id": _userId,
          }));
      if (response.statusCode == 200) {
        print("reach");
        print(response.statusCode);
      } else {
        print(response.statusCode);
        print("print reach");
      }
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<void> mechaArrival() async {
    print(_historyId);
    try {
      final response = await http.post("$BASE_URL/mecha/arrival",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "_id": _historyId,
          }));

      if (response.statusCode == 200) {
        print(response.statusCode);
        print("arrival");
      } else {
        print("arrival");
        print(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<void> mechaCancelCheckPoint() async {
    try {
      final response = await http.post("$BASE_URL/mecha/checkpoint/cencel",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "_id": _historyId,
          }));
      if (response.statusCode == 200) {
        print("cancel check point");
        _isCancel = jsonDecode(response.body);
        notifyListeners();
      } else {
        print(response.body);
        print(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<void> donePoint() async {
    print(_historyId);
    try {
      final response = await http.post("$BASE_URL/mecha/checkpoint/done",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({"_id": _historyId})); //historyid
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print("done checkpoint succes ${response.body}");
        _isDone = jsonData[0] == 0 ? false : true;
        notifyListeners();
      } else {
        print(response.body);
        print(response.statusCode);
        print("done error");
      }
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<void> mechaPayment() async {
    try {
      final response = await http.post("$BASE_URL/mecha/payment",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "merchantid": "5e87533b0e5c160b48427c42",
            "amount": 120,
            "txnid": "123",
            "time": "454545545454",
            "historyids": [
              "5e8360496a8fe23f64878930",
              "5e8360a2dec30e109898b080"
            ]
          }));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData);
      } else {
        print(response.body);
        print(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }
}
