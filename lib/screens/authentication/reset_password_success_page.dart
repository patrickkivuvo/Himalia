import 'package:flutter/material.dart';
import 'package:himalia/screens/authentication/auth_screen.dart';
import 'package:himalia/utils/constants.dart';
import 'package:sizer/sizer.dart';

import '../../utils/widgets.dart';

class ResetPasswordSuccessPage extends StatelessWidget {
  const ResetPasswordSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 25.h,
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/himalia_logo.png',
                  height: 300,
                  width: 300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Congrats',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: kPrimaryColor),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Your account is ready to use',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildGlobalButton(
                  buttonPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AuthenticationScreen()));
                  },
                  buttonLabel: 'Login',
                  buttonColor: kPrimaryColor,
                  buttonTextColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
