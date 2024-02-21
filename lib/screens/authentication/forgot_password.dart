import 'package:flutter/material.dart';
import 'package:himalia/screens/authentication/otp_confirmation.dart';
import 'package:himalia/utils/constants.dart';
import 'package:sizer/sizer.dart';

import '../../utils/widgets.dart';

enum PasswordResetOptions { email, phoneNumber }

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  PasswordResetOptions _resetOptions = PasswordResetOptions.phoneNumber;
  bool phoneSelected = true;
  bool emailSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 5.h,
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  width: 20.w,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Forgot Password ?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Select which contact details should we use to reset\nyour password',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: phoneSelected == true ? kPrimaryColor : Colors.grey,
                  ),
                ),
                child: ListTile(
                  title: const Text('via SMS:'),
                  subtitle: const Text('+6282******39'),
                  leading: Radio<PasswordResetOptions>(
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => kPrimaryColor),
                    value: PasswordResetOptions.phoneNumber,
                    groupValue: _resetOptions,
                    onChanged: (PasswordResetOptions? value) {
                      setState(() {
                        _resetOptions = value!;
                        emailSelected = false;
                        phoneSelected = true;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: emailSelected == true ? kPrimaryColor : Colors.grey,
                  ),
                ),
                child: ListTile(
                  title: const Text('via Email:'),
                  subtitle: const Text('email*******@gmail.com'),
                  leading: Radio<PasswordResetOptions>(
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => kPrimaryColor),
                    value: PasswordResetOptions.email,
                    groupValue: _resetOptions,
                    onChanged: (PasswordResetOptions? value) {
                      setState(() {
                        _resetOptions = value!;
                        phoneSelected = false;
                        emailSelected = true;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            buildGlobalButton(
                buttonPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const OtpResetConfirmation()));
                },
                buttonLabel: 'Continue',
                buttonColor: kPrimaryColor,
                buttonTextColor: Colors.white),
          ],
        ),
      ),
    );
  }
}
