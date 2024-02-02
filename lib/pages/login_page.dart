import 'package:projet_frontend/components.dart';
import 'package:projet_frontend/pages/signin_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../model/authentication_result.dart';
import '../model/user_account.dart';
import '../services/car_api.dart';
import '../services/login_state.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  final userRoutes = UserAccountRoutes();

  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String _login;
  late String _password;
  var processLogin = false;
  late Future<AuthenticationResult> _authResult;

  _dologin() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState?.save();
    _authResult =
        widget.userRoutes.authenticate(_login, _password).then((authResult) {
          Provider.of<LoginState>(context, listen: false).token = authResult.token;
          Provider.of<LoginState>(context, listen: false).user = UserAccount(
              login: authResult.login);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => MyHomePage(
                title: 'Cars',
              )));
          return authResult;
        });
    setState(() {
      processLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 200, 20, 20),
            child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text('Cars', style: TextStyle(fontSize: 50)),
                      MySizedBox(
                          child: TextFormField(
                              onChanged: (value) => _login = value.toString(),
                              decoration: InputDecoration(labelText: 'Login'),
                              validator: (value) => stringNotEmptyValidator(
                                  value, 'Please enter a Login'))),
                      MySizedBox(
                          child: TextFormField(
                              onChanged: (value) => _password = value.toString(),
                              decoration: InputDecoration(labelText: 'Password'),
                              validator: (value) => stringNotEmptyValidator(
                                  value, 'Please enter a Password'),
                              obscureText: true)),
                      if (processLogin)
                        FutureBuilder(
                            future: _authResult,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                processLogin = false;
                                final errorMessage =
                                snapshot.error is StatusErrorException
                                    ? "Invalid username or password"
                                    : "Network error, please try again later";
                                return Column(children: [
                                  MyText(errorMessage),
                                  MySizedBox(
                                      child: MyElevatedButton(
                                          onPressed: () => _dologin(),
                                          text: 'Login'))
                                ]);
                              }
                              return Center(child: CircularProgressIndicator());
                            })
                      else
                        MySizedBox(
                            child: MyElevatedButton(
                                onPressed: () => _dologin(), text: 'Login')),
                      MySizedBox(
                          child: MyElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SigninPage()));
                              },
                              text: 'Sign in'))
                    ],
                  ),
                ))));
  }
}
