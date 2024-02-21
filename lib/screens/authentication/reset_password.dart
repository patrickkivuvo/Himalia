// ignore_for_file: unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:himalia/screens/authentication/reset_password_success_page.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';
import '../../utils/widgets.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final bool _rememberUser = false;
  String _displayText = '';
  double _strength = 0;
  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");
  bool isLoading = false;

  resetPassword() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$accountsBaseUrl/set-password/'));
    request.fields.addAll({
      'email': emailController.text,
      'password': newPasswordController.text,
      'password2': confirmNewPasswordController.text
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const ResetPasswordSuccessPage()),
          (Route<dynamic> route) => false);
      setState(() {
        isLoading = false;
      });
    } else {
      var data = jsonDecode(await response.stream.bytesToString());
      print(data);
      if (data.containsKey("email")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User with email provided does not exist'),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  void _checkPassword(String value) {
    if (newPasswordController.text.isEmpty) {
      setState(() {
        _strength = 0;
        _displayText = '';
      });
    } else if (newPasswordController.text.length < 6) {
      setState(() {
        _strength = 1 / 4;
        _displayText = 'Your password is too short';
      });
    } else if (newPasswordController.text.length < 8) {
      setState(() {
        _strength = 2 / 4;
        _displayText = 'Your password is acceptable but not strong';
      });
    } else {
      if (!letterReg.hasMatch(newPasswordController.text) ||
          !numReg.hasMatch(newPasswordController.text)) {
        setState(() {
          _strength = 3 / 4;
          _displayText = 'Your password is strong';
        });
      } else {
        setState(() {
          _strength = 1;
          _displayText = 'Your password is great';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kPrimaryColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Reset Password',
          style: TextStyle(color: kPrimaryColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 5.h,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Create a new password',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                ),
              ),
              buildGlobalTextField(
                nameController: emailController,
                title: 'Email',
                textInputColor: Colors.black,
                borderColor: kPrimaryColor,
                labelColor: kPrimaryColor,
                textInput: TextInputType.text,
                isEnabled: true,
                leadingIcon: Icon(
                  Icons.key,
                  color: kPrimaryColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: 100.w,
                  child: TextField(
                    onChanged: (value) => _checkPassword(value),
                    keyboardType: TextInputType.text,
                    enabled: true,
                    style: const TextStyle(color: Colors.black),
                    controller: newPasswordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.key,
                        color: kPrimaryColor,
                      ),
                      border: const OutlineInputBorder(),
                      labelText: 'New Password',
                      labelStyle: TextStyle(color: kPrimaryColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          color: kPrimaryColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: LinearProgressIndicator(
                  value: _strength,
                  backgroundColor: Colors.grey[300],
                  color: _strength <= 1 / 4
                      ? Colors.red
                      : _strength == 2 / 4
                          ? Colors.yellow
                          : _strength == 3 / 4
                              ? Colors.blue
                              : Colors.green,
                  minHeight: 15,
                ),
              ),
              Text(
                _displayText,
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              buildGlobalTextField(
                nameController: confirmNewPasswordController,
                title: 'Confirm new password',
                textInputColor: Colors.black,
                borderColor: kPrimaryColor,
                labelColor: kPrimaryColor,
                textInput: TextInputType.text,
                isEnabled: true,
                leadingIcon: Icon(
                  Icons.key,
                  color: kPrimaryColor,
                ),
              ),
              isLoading == false
                  ? buildGlobalButton(
                      buttonPress: () {
                        if (emailController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Email field is required"),
                            ),
                          );
                        } else if (newPasswordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("New password field is required"),
                            ),
                          );
                        } else if (confirmNewPasswordController.text !=
                            newPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Both passwords should match"),
                            ),
                          );
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          resetPassword();
                        }
                      },
                      buttonLabel: 'Save',
                      buttonColor: kPrimaryColor,
                      buttonTextColor: Colors.white)
                  : SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
