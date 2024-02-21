import 'package:flutter/material.dart';
import 'package:himalia/screens/authentication/reset_password.dart';
import 'package:himalia/utils/constants.dart';
import 'package:sizer/sizer.dart';
import '../../utils/widgets.dart';

class OtpResetConfirmation extends StatefulWidget {
  const OtpResetConfirmation({Key? key}) : super(key: key);

  @override
  State<OtpResetConfirmation> createState() => _OtpResetConfirmationState();
}

class _OtpResetConfirmationState extends State<OtpResetConfirmation> {
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? typedOtp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OTP Confirmation',
          style: TextStyle(color: kPrimaryColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10.h,
            ),
            const Text('Code has been send to your email'),
            const SizedBox(
              height: 30,
            ),
            // Implement 4 input fields
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OtpInput(_fieldOne, true),
                  OtpInput(_fieldTwo, false),
                  OtpInput(_fieldThree, false),
                  OtpInput(_fieldFour, false),
                  OtpInput(_fieldFive, false),
                  OtpInput(_fieldSix, false),
                ],
              ),
            ),
            buildGlobalTextField(
              nameController: emailController,
              title: 'Enter Email',
              textInputColor: Colors.black,
              borderColor: kPrimaryColor,
              labelColor: kPrimaryColor,
              textInput: TextInputType.emailAddress,
              isEnabled: true,
              leadingIcon: Icon(
                Icons.email,
                color: kPrimaryColor,
              ),
            ),

            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      'Resend Code in',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      '30',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildGlobalButton(
                  buttonPress: () {
                    setState(() {
                      typedOtp = _fieldOne.text +
                          _fieldTwo.text +
                          _fieldThree.text +
                          _fieldFour.text +
                          _fieldFive.text +
                          _fieldSix.text;
                    });
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ResetPassword()));
                  },
                  buttonLabel: 'Verify',
                  buttonColor: kPrimaryColor,
                  buttonTextColor: Colors.white),
            ),

            const SizedBox(
              height: 30,
            ),
            // Display the entered OTP code
          ],
        ),
      ),
    );
  }
}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 50,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: kPrimaryColor,
              ),
            ),
            border: const OutlineInputBorder(),
            counterText: '',
            hintStyle: TextStyle(color: kPrimaryColor)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
