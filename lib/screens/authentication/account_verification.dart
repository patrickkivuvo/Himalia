import 'package:flutter/material.dart';
import 'package:himalia/utils/constants.dart';
import 'package:sizer/sizer.dart';
import '../../utils/widgets.dart';

class AccountVerification extends StatefulWidget {
  const AccountVerification({Key? key}) : super(key: key);

  @override
  State<AccountVerification> createState() => _AccountVerificationState();
}

class _AccountVerificationState extends State<AccountVerification> {
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? typedOtp;
  bool isLoading = false;

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
            const Text('Verification Code has been sent to your email'),
            const SizedBox(
              height: 30,
            ),
            // Implement 4 input fields
            Row(
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
            buildGlobalTextField(
                nameController: emailController,
                title: "Enter Email",
                textInputColor: Colors.black,
                borderColor: kPrimaryColor,
                labelColor: kPrimaryColor,
                textInput: TextInputType.emailAddress,
                leadingIcon: Icon(
                  Icons.email,
                  color: kPrimaryColor,
                ),
                isEnabled: true),
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
            isLoading == false
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildGlobalButton(
                        buttonPress: () {
                          setState(() {
                            isLoading = true;
                            typedOtp = _fieldOne.text +
                                _fieldTwo.text +
                                _fieldThree.text +
                                _fieldFour.text +
                                _fieldFive.text +
                                _fieldSix.text;
                          });
                          // Removed the call to verifyAccount()
                        },
                        buttonLabel: 'Verify',
                        buttonColor: kPrimaryColor,
                        buttonTextColor: Colors.white),
                  )
                : SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
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
