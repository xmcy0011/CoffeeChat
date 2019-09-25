import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 64),
                child: SizedBox(
                  height: 160,
                  child: Image.asset('assets/logo.png'),
                ),
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              SizedBox(
                height: 120,
                child: Image.asset('assets/thumb.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}