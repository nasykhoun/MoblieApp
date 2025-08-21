import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'student_login_screen.dart';
import 'student_service.dart';

class StudentRegisterScreen extends StatefulWidget {
	const StudentRegisterScreen({super.key});

	@override
	State<StudentRegisterScreen> createState() => _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends State<StudentRegisterScreen> {
	static const String emailPattern =
		 r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
     r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
     r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
     r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
     r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
     r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
     r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
	final _formKey = GlobalKey<FormState>();
	final _nameCtrl = TextEditingController();
	final _emailCtrl = TextEditingController();
	final _passCtrl = TextEditingController();
	bool _hidePassword = true;
	String _output = "";

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: Text("Student Registration"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 48, 50, 51),
      ),
      body: _buildBody());
	}

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
								SizedBox(height: 10),
								_buildNameTextField(),
								SizedBox(height: 10),
								_buildEmailTextField(),
								SizedBox(height: 10),
								_buildPasswordTextField(),
								SizedBox(height: 10),
								_buildRegisterButton(),
								SizedBox(height: 10),
								_buildLoginLink(),
								SizedBox(height: 10),
								_buildOutput(),
							],
						),
					),
				),
			),
		);
	}

	Widget _buildNameTextField() {
		return TextFormField(
			controller: _nameCtrl,
			decoration: InputDecoration(
				prefixIcon: Icon(Icons.person),
				hintText: "Enter name",
				border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
			),
			textInputAction: TextInputAction.next,
			validator: (value) {
				if (value == null || value.isEmpty) {
					return "Name is required";
				}
				return null;
			},
		);
	}

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
				final regex = RegExp(emailPattern);
				return value != null && value.isNotEmpty && !regex.hasMatch(value)
						? 'Enter a valid email address'
						: null;
			},
		);
	}

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
				if (value == null || value.isEmpty) {
					return "Password is required";
				}
				if (value.length < 6) {
					return "Password must be at least 6 characters";
				}
				return null;
			},
		);
	}

	Widget _buildRegisterButton() {
		return SizedBox(
			width: double.maxFinite,
			height: 50,
			child: ElevatedButton(
				onPressed: () {
					if (_formKey.currentState!.validate()) {
						// TODO: Call StudentService.insert or your registration API here
						setState(() {
							_output = 'Registered: ${_nameCtrl.text}, ${_emailCtrl.text}';
						});
						Navigator.of(context).push(
							CupertinoPageRoute(builder: (context) => StudentLoginScreen()),
						);
					}
				},
				child: Text("Register"),
			),
		);
	}

	Widget _buildLoginLink() {
		return TextButton(
			onPressed: () {
				Navigator.of(context).push(
					CupertinoPageRoute(builder: (context) => StudentLoginScreen()),
				);
			},
			child: Text("Already have an account? Login"),
		);
	}

	Widget _buildOutput() {
		return Text("Output: $_output");
	}
}
