import 'package:flutter/material.dart';
import 'package:himalia/screens/authentication/auth_screen.dart';
import 'package:sizer/sizer.dart';
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
  double _strength = 0;
  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");
  bool isLoading = false;

  void _checkPassword(String value) {
    if (newPasswordController.text.isEmpty) {
      setState(() {
        _strength = 0;
      });
    } else if (newPasswordController.text.length < 6) {
      setState(() {
        _strength = 1 / 4;
      });
    } else if (newPasswordController.text.length < 8) {
      setState(() {
        _strength = 2 / 4;
      });
    } else {
      if (!letterReg.hasMatch(newPasswordController.text) ||
          !numReg.hasMatch(newPasswordController.text)) {
        setState(() {
          _strength = 3 / 4;
        });
      } else {
        setState(() {
          _strength = 1;
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
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const AuthenticationScreen()));
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
