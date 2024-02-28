import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogIn = true;
  final _formKey = GlobalKey<FormState>();
  String? _enteredEmail = '';
  String? _enteredPass = '';

  void onSubmit() {
    bool isValid = _formKey.currentState!.validate();
    if (isValid == true) {
      _formKey.currentState!.save();
      print(_enteredEmail);
      print(_enteredPass);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Image.asset("assets/images/chat.png"),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            textCapitalization: TextCapitalization.none,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration:
                                const InputDecoration(labelText: "Email ID"),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.contains('@') == false) {
                                return "Incorrect email";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _enteredEmail = value;
                              });
                            },
                          ),
                          TextFormField(
                            onSaved: (value) {
                              setState(() {
                                _enteredPass = value;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: "Password",
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return "Incorrect password";
                              } else {
                                return null;
                              }
                            },
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer),
                              onPressed: () {
                                onSubmit();
                              },
                              child: const Text("Sign in")),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogIn = !_isLogIn;
                                });
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer),
                              child: Text(_isLogIn
                                  ? "Already have an account"
                                  : "Create new account"))
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
