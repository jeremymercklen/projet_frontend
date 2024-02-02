import 'dart:convert';

import 'package:projet_frontend/model/user_account.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../model/authentication_result.dart';
import '../model/car.dart';
import 'login_state.dart';

class StatusErrorException {
  final int _statusCode;

  const StatusErrorException(this._statusCode);

  get statusCode => _statusCode;
}

class CarAPI {
  static const apiServer = '10.0.2.2:3333';
  static const apiUrl = '';
}

class UserAccountRoutes extends CarAPI {
  static const userAccountRoutes = '${CarAPI.apiUrl}/useraccount';
  static const authRoutes = '$userAccountRoutes/authenticate';

  Future insert(UserAccount userAccount) async {
    var result = await http.post(
        Uri.http(CarAPI.apiServer, '$userAccountRoutes'),
        body: userAccount.toMap());
    if (result.statusCode != 200) throw StatusErrorException(result.statusCode);
  }

  Future get(String login) async {
    var result =
    await http.get(Uri.http(CarAPI.apiServer, '$userAccountRoutes/$login'));
    if (result.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<AuthenticationResult> authenticate(
      String login, String password) async {
    var result = await http.post(Uri.http(CarAPI.apiServer, authRoutes),
        body: {'login': login, 'password': password});
    if (result.statusCode != 200) throw StatusErrorException(result.statusCode);
    final Map<String, dynamic> datas = jsonDecode(result.body);
    return AuthenticationResult.fromMap(datas);
  }

  Future<String> refreshToken(context) async {
    var token = Provider.of<LoginState>(context, listen: false).token;
    var result = await http.get(
        Uri.http(CarAPI.apiServer, '$userAccountRoutes/refreshtoken'),
        headers: {'Authorization': 'Bearer $token'});
    if (result.statusCode == 200)
      return jsonDecode(result.body)["token"];
    else
      throw StatusErrorException(result.statusCode);
  }
}

class CarRoutes extends CarAPI {
  static const carRoutes = '${CarAPI.apiUrl}/car';
  var userRoutes = UserAccountRoutes();

  Future<List<Car>> get(context) async {
    List<Car> cars = [];

    try {
      var value = await userRoutes.refreshToken(context);
      Provider.of<LoginState>(context, listen: false).token = value;

      //var token = Provider.of<LoginState>(context, listen: false).token;
      var result = await http.get(Uri.http(CarAPI.apiServer, '$carRoutes'),
          headers: {'Authorization': 'Bearer $value'});
      if (result.statusCode == 200) {
        var datas = jsonDecode(result.body);
        for (var data in datas) {
          var car = Car.fromMap(data);
          cars.add(car);
        }
      }
    } on StatusErrorException catch (error) {
      if ((error.statusCode == 401))
        Provider.of<LoginState>(context, listen: false).disconnect();
    }
    ;
    return cars;
  }

  Future insert(Car car, context) async {
    var token = Provider.of<LoginState>(context, listen: false).token;
    await http.post(Uri.http(CarAPI.apiServer, carRoutes),
        headers: {'Authorization': 'Bearer $token'}, body: car);
  }
}
