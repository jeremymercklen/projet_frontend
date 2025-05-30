import 'package:projet_frontend/components.dart';
import 'package:projet_frontend/models/user_account.dart';
import 'package:projet_frontend/services/list_anime_api.dart';
import 'package:projet_frontend/pages/login_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SigninPage extends StatefulWidget {
  SigninPage({super.key});

  final userRoutes = UserAccountRoutes();

  @override
  State<StatefulWidget> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  late String _login;
  late String _password;
  String? _loginError;
  var processSignin = false;

  _signin() async {
    if (!_formKey.currentState!.validate()) return;
    _loginError = null;
    try {
      final exists = await widget.userRoutes.get(_login);
      if (exists) {
        _loginError = 'Login already in use';
        setState(() {
        });
        return;
      }
    } catch (e) {}

    if (context.mounted) {
      try {
        setState(() {
          processSignin = true;
        });
        await widget.userRoutes
            .insert(UserAccount(login: _login, password: _password));
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()));
        }
      } catch (error) {
        showNetworkErrorDialog(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Sign up'),
        ),
        body: ListView.builder(
            itemCount: 1,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) => Form(
                key: _formKey,
                child: Column(
                  children: [
                    MySizedBox(
                        child: TextFormField(
                            onChanged: (value) => _login = value.toString(),
                            decoration: InputDecoration(labelText: 'Login'),
                            validator: (value) {
                              if (_loginError != null) {
                                return _loginError;
                              }
                              return stringNotEmptyValidator(
                                  value, 'Please enter a Login');
                            },)),
                    MySizedBox(
                        child: TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) => _password = value.toString(),
                            validator: (value) => stringNotEmptyValidator(
                                value, 'Please enter a password'),
                            obscureText: true)),
                    MySizedBox(
                        child: TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Repeat password'),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please repeat the password';
                              }
                              if (value != _password) {
                                return 'The passwords does not matches';
                              }
                              return null;
                            },
                            obscureText: true)),
                    MyPadding(child: MySizedBox(
                        child: MyElevatedButton(
                            onPressed: () => _signin(), text: 'Sign up')))
                  ],
                ))));
  }
}
