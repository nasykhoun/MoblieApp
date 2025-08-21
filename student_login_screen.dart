import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hwreadapi/student_module/student_register_screen.dart';

import 'student_screen.dart';
import 'student_service.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  final _formKey = GlobalKey<FormState>();

  Widget _buildBody() {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // _builLogo(),
                SizedBox(height: 10),
                _buildEmailTextField(),
                SizedBox(height: 10),
                _buildPasswordTextField(),
                SizedBox(height: 10),
                _buildLoginButton(),
                SizedBox(height: 10),
                _buildRegisterLink(),
                SizedBox(height: 10),
                _buildOutput(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final _img =
      "https://img.freepik.com/premium-photo/young-girl-wearing-yellow-tshirt-smiling-facing-camera-empty-space-isolated-bright-yellow_74379-2763.jpg?semt=ais_hybrid&w=740";

  Widget _builLogo() {
    return CircleAvatar(radius: 70, backgroundImage: NetworkImage(_img));
  }

  final _emailCtrl = TextEditingController();

  Widget _buildEmailTextField() {
    return TextFormField(
      controller: _emailCtrl,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        hintText: "Enter email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        const pattern =
            r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
            r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
            r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
            r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
            r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
            r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
            r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
        final regex = RegExp(pattern);

        return value!.isNotEmpty && !regex.hasMatch(value)
            ? 'Enter a valid email address'
            : null;
      },
    );
  }

  bool _hidePassword = true;
  final _passCtrl = TextEditingController();

  Widget _buildPasswordTextField() {
    return TextFormField(
      controller: _passCtrl,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.key),
        hintText: "Enter password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _hidePassword = !_hidePassword;
            });
          },
          icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      textInputAction: TextInputAction.send,
      obscureText: _hidePassword,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password is required";
        }

        if (value.length < 6) {
          return "Password is required at least 6 character";
        }

        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.maxFinite,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            StudentService.login(
                  _emailCtrl.text.toLowerCase().trim(),
                  _passCtrl.text.trim(),
                )
                .then((loggedUser) {
                  setState(() {
                    _output = loggedUser.toJson().toString();
                  });
                  Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(
                      builder: (context) => StudentScreen(loggedUser),
                    ),
                  );
                })
                .onError((e, s) {
                  setState(() {
                    _output = e.toString();
                  });
                });
          }
        },
        child: Text("Login"),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentRegisterScreen()),
        );
      },
      child: Text("Register a New Account"),
    );
  }

  String _output = "";

  Widget _buildOutput() {
    return Text("Output: $_output");
  }
}
