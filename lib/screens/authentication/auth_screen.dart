// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:himalia/screens/profile/profile_screen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:himalia/utils/constants.dart';
import 'package:himalia/utils/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../utils/helper.dart';
import 'account_verification.dart';
import 'otp_confirmation.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController emailController = TextEditingController();
  TextEditingController resetEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController registerEmailController = TextEditingController();
  TextEditingController registerFullNameController = TextEditingController();
  TextEditingController registerLicenceNumberController =
      TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  TextEditingController registerPhoneNumberController = TextEditingController();
  TextEditingController registerConfirmPasswordController =
      TextEditingController();
  String nationalIdPath = "";
  String? nationalIdName;
  String signedContractPath = "";
  String? signedContractName;
  String? selectedCategory;
  String? selectedCategoryID;
  DateTime? selectedIssueDate;
  String selectedIssueDateString = "";
  String? registerEmailError;
  String? registerPhoneNumberError;
  String? loginEmailError;
  String? loginPasswordError;
  bool _obscureText = true;
  bool isSelected = false;
  bool isRequesting = false;
  bool isContractSelected = false;
  bool emailRegisterFieldError = false;
  bool emailLoginFieldError = false;
  bool passwordLoginFieldError = false;
  bool phoneNumberRegisterFieldError = false;
  bool isPinning = false;
  bool isLoading = false;
  bool isLogging = false;
  String _displayText = '';
  double _strength = 0;
  String phoneNumberUser = "";
  var long = "";
  var lat = "";
  List allServiceCategories = [];
  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  resetPasswordRequest() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$accountsBaseUrl/password-reset/'));
    request.fields.addAll({'email': resetEmailController.text});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        isRequesting = false;
      });
      print(await response.stream.bytesToString());
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const OtpResetConfirmation()),
          (Route<dynamic> route) => false);
    } else {
      print(response.reasonPhrase);
      var data = jsonDecode(await response.stream.bytesToString());
      print(data);
      setState(() {
        isRequesting = false;
      });
    }
  }

  showAlertDialog(
    BuildContext context,
  ) {
    AlertDialog alert = AlertDialog(
      title: const Text('Password Reset Request'),
      actions: [
        Center(
          child: Column(
            children: [
              buildGlobalTextField(
                nameController: resetEmailController,
                title: 'Enter Your Email',
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
              isRequesting == false
                  ? buildGlobalButton(
                      buttonPress: () {
                        setState(() {
                          isRequesting = true;
                        });
                        resetPasswordRequest();
                      },
                      buttonLabel: 'Submit',
                      buttonColor: kPrimaryColor,
                      buttonTextColor: Colors.white)
                  : SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      )),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        )
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  loginHsp() async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$accountsBaseUrl/login/'));
    request.fields.addAll(
        {'email': emailController.text, 'password': passwordController.text});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      var pref = await SharedPreferences.getInstance();
      pref.setString("access_token", data['access']);
      pref.setString("refresh_token", data['refresh']);
      pref.setString("hsp_id", data['hsp_id'].toString());
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
          (Route<dynamic> route) => false);
      print(data);
      print(data['refresh']);
      setState(() {
        isLogging = false;
      });
    } else {
      setState(() {
        isLogging = false;
      });
      var data = jsonDecode(await response.stream.bytesToString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['detail']),
        ),
      );
      print(data);
      if (data.containsKey("email")) {
        setState(() {
          emailLoginFieldError = true;
          loginEmailError = data['email'];
        });
      } else if (data.containsKey("password")) {
        setState(() {
          passwordLoginFieldError = true;
          loginPasswordError = data['password'];
        });
      }
    }
  }

  registerHsp() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$accountsBaseUrl/register-hsp/'));
    request.fields.addAll({
      'email': registerEmailController.text,
      'password': registerPasswordController.text,
      'password2': registerConfirmPasswordController.text,
      'full_name': registerFullNameController.text,
      'phone_number': phoneNumberUser,
      'date_of_license_issue': selectedIssueDateString,
      'location': ' {"type": "Point", "coordinates": [$long, $lat]}',
      'service_category': selectedCategoryID!,
      'license_number': registerLicenceNumberController.text
    });
    request.files
        .add(await http.MultipartFile.fromPath('national_id', nationalIdPath));
    request.files.add(await http.MultipartFile.fromPath(
        'signed_contract', signedContractPath));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      print(await response.stream.bytesToString());
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AccountVerification()),
          (Route<dynamic> route) => false);
      setState(() {
        isLoading = false;
      });
    } else {
      var data = jsonDecode(await response.stream.bytesToString());

      print(data);
      setState(() {
        isLoading = false;
      });
      if (data.containsKey("email")) {
        setState(() {
          emailRegisterFieldError = true;
          registerEmailError = data['email'];
        });
      } else if (data.containsKey("phone_number")) {
        setState(() {
          phoneNumberRegisterFieldError = true;
          registerPhoneNumberError = data['phone_number'];
        });
      }
    }
  }

  void getLocation() async {
    LocationPermission per = await Geolocator.checkPermission();
    if (per == LocationPermission.denied ||
        per == LocationPermission.deniedForever) {
      print("permission denied");
      LocationPermission per1 = await Geolocator.requestPermission();
      setState(() {
        isPinning = false;
      });
    } else {
      Position currentLoc = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        isPinning = false;
        long = currentLoc.longitude.toString();
        lat = currentLoc.latitude.toString();
      });
    }
  }

  void _checkPassword(String value) {
    if (registerPasswordController.text.isEmpty) {
      setState(() {
        _strength = 0;
        _displayText = '';
      });
    } else if (registerPasswordController.text.length < 6) {
      setState(() {
        _strength = 1 / 4;
        _displayText = 'Your password is too short';
      });
    } else if (registerPasswordController.text.length < 8) {
      setState(() {
        _strength = 2 / 4;
        _displayText = 'Your password is acceptable but not strong';
      });
    } else {
      if (!letterReg.hasMatch(registerPasswordController.text) ||
          !numReg.hasMatch(registerPasswordController.text)) {
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

  getServiceCategories() async {
    var request =
        http.Request('GET', Uri.parse('$accountsBaseUrl/service-categories/'));
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getServiceCategories();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/himalia_logo.png",
                  height: 100,
                  width: 100,
                ),
              ),
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'WELCOME TO HIMALIA',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 60,
                      margin: const EdgeInsets.only(left: 60),
                      child: TabBar(
                        tabs: const [
                          SizedBox(
                            width: 70.0,
                            child: Text(
                              'SIGN IN',
                            ),
                          ),
                          SizedBox(
                            width: 75.0,
                            child: Text(
                              'SIGN UP',
                            ),
                          )
                        ],
                        unselectedLabelColor: const Color(0xffacb3bf),
                        indicatorColor: kPrimaryColor,
                        labelColor: kPrimaryColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: 3.0,
                        indicatorPadding: const EdgeInsets.all(10),
                        isScrollable: false,
                        controller: _tabController,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child:
                    TabBarView(controller: _tabController, children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                        child: Column(
                      children: [
                        buildGlobalTextField(
                          nameController: emailController,
                          title: 'Enter Email',
                          textInputColor: Colors.black,
                          borderColor: emailLoginFieldError == true
                              ? Colors.red
                              : kPrimaryColor,
                          labelColor: kPrimaryColor,
                          textInput: TextInputType.emailAddress,
                          isEnabled: true,
                          leadingIcon: Icon(
                            Icons.email,
                            color: kPrimaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            width: 100.w,
                            child: TextField(
                              obscureText: _obscureText,
                              keyboardType: TextInputType.text,
                              enabled: true,
                              style: const TextStyle(color: Colors.black),
                              controller: passwordController,
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {
                                    _toggle();
                                  },
                                  child: Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.key,
                                  color: kPrimaryColor,
                                ),
                                border: const OutlineInputBorder(),
                                labelText: "Password",
                                labelStyle: TextStyle(color: kPrimaryColor),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                    color: passwordLoginFieldError == true
                                        ? Colors.red
                                        : kPrimaryColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                    color: passwordLoginFieldError == true
                                        ? Colors.red
                                        : kPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showAlertDialog(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor),
                              ),
                            ),
                          ),
                        ),
                        isLogging == false
                            ? buildGlobalButton(
                                buttonPress: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ProfileScreen()),
                                      (Route<dynamic> route) => false);
                                },
                                buttonLabel: 'SIGN IN',
                                buttonColor: kPrimaryColor,
                                buttonTextColor: Colors.white)
                            : SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  color: kPrimaryColor,
                                )),
                      ],
                    )),
                  ),
                  SingleChildScrollView(
                    child: Container(
                        child: Column(
                      children: [
                        buildGlobalTextField(
                          nameController: registerFullNameController,
                          title: 'Full Name',
                          textInputColor: Colors.black,
                          borderColor: kPrimaryColor,
                          labelColor: kPrimaryColor,
                          textInput: TextInputType.text,
                          isEnabled: true,
                          leadingIcon: Icon(
                            Icons.emoji_emotions_outlined,
                            color: kPrimaryColor,
                          ),
                        ),
                        buildGlobalTextField(
                          nameController: registerEmailController,
                          title: 'Enter Email',
                          textInputColor: Colors.black,
                          borderColor: emailRegisterFieldError == true
                              ? Colors.red
                              : kPrimaryColor,
                          labelColor: kPrimaryColor,
                          textInput: TextInputType.emailAddress,
                          isEnabled: true,
                          leadingIcon: Icon(
                            Icons.email,
                            color: kPrimaryColor,
                          ),
                        ),
                        emailRegisterFieldError == true
                            ? Text(
                                registerEmailError.toString(),
                                style: TextStyle(color: kPrimaryColor),
                              )
                            : const SizedBox(
                                height: 3,
                              ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: IntlPhoneField(
                            disableLengthCheck: true,
                            decoration: InputDecoration(
                              labelText: 'Phone number',
                              hintText: '700123456',
                              hintStyle: TextStyle(color: kPrimaryColor),
                              labelStyle: TextStyle(color: kPrimaryColor),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  color: phoneNumberRegisterFieldError == true
                                      ? Colors.red
                                      : kPrimaryColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  color: phoneNumberRegisterFieldError == true
                                      ? Colors.red
                                      : kPrimaryColor,
                                ),
                              ),
                            ),
                            initialCountryCode: 'KE',
                            onChanged: (phone) {
                              if (phone.completeNumber.length == 13) {
                                print(phone.completeNumber);
                                String phoneNumberInput = phone.completeNumber;
                                String formattedPhoneNumber =
                                    phoneNumberInput.substring(1);
                                phoneNumberUser = "+$formattedPhoneNumber";
                                print(phoneNumberUser);
                              }
                            },
                          ),
                        ),
                        phoneNumberRegisterFieldError == true
                            ? Text(
                                registerPhoneNumberError.toString(),
                                style: TextStyle(color: kPrimaryColor),
                              )
                            : const SizedBox(
                                height: 3,
                              ),
                        buildGlobalTextField(
                          nameController: registerLicenceNumberController,
                          title: 'License Number',
                          textInputColor: Colors.black,
                          borderColor: kPrimaryColor,
                          labelColor: kPrimaryColor,
                          textInput: TextInputType.text,
                          isEnabled: true,
                          leadingIcon: Icon(
                            Icons.numbers,
                            color: kPrimaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            height: 60.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border:
                                  Border.all(color: kPrimaryColor, width: 1),
                            ),
                            child: ListTile(
                              title: Text(
                                selectedIssueDate == null
                                    ? 'Select Date of Licence Issue?'
                                    : Helpers.getParamDateFormat(
                                        selectedIssueDate!),
                                style: TextStyle(
                                  color: kPrimaryColor,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.calendar_today,
                                    color: kPrimaryColor),
                                onPressed: () async {
                                  await showDatePicker(
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: kPrimaryColor,
                                                  onPrimary: Colors.yellow,
                                                  onSurface: kPrimaryColor,
                                                ),
                                                textButtonTheme:
                                                    TextButtonThemeData(
                                                  style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        kPrimaryColor, // button text color
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                          context: context,
                                          initialDate: selectedIssueDate ??
                                              DateTime.now(),
                                          firstDate: DateTime(1920),
                                          lastDate: DateTime.now())
                                      .then((date) {
                                    setState(() {
                                      selectedIssueDate = date!;
                                      selectedIssueDateString =
                                          selectedIssueDate
                                              .toString()
                                              .split(' ')[0];
                                    });
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              hint: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    size: 16,
                                    color: kPrimaryColor,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Select Service Category',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: allServiceCategories
                                  .map((category) => DropdownMenuItem(
                                        onTap: () {
                                          setState(() {
                                            selectedCategoryID =
                                                category['id'].toString();
                                          });
                                        },
                                        value: category['name'],
                                        child: Text(
                                          category['name'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: kPrimaryColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: selectedCategory,
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value.toString();
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              iconSize: 14,
                              iconEnabledColor: kPrimaryColor,
                              iconDisabledColor: Colors.grey,
                              buttonHeight: 60,
                              buttonWidth: 100.w,
                              buttonPadding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              buttonDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: kPrimaryColor,
                                  ),
                                  color: Colors.white),
                              buttonElevation: 2,
                              itemHeight: 40,
                              itemPadding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              dropdownMaxHeight: 200,
                              dropdownWidth: 200,
                              dropdownPadding: null,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                              ),
                              dropdownElevation: 8,
                              scrollbarRadius: const Radius.circular(40),
                              scrollbarThickness: 6,
                              scrollbarAlwaysShow: true,
                              offset: const Offset(-20, 0),
                            ),
                          ),
                        ),
                        buildGlobalButton(
                            buttonPress: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();
                              if (result != null) {
                                PlatformFile file = result.files.first;
                                setState(() {
                                  nationalIdPath = file.path.toString();
                                  nationalIdName = file.name.toString();
                                  isSelected = true;
                                });
                                print(file.name);
                                print(file.path);
                              } else {
                                // User canceled the picker
                              }
                            },
                            buttonLabel: "Upload National ID",
                            buttonColor: kPrimaryColor,
                            buttonTextColor: Colors.white),
                        isSelected == true
                            ? Text(
                                nationalIdName!,
                                style: TextStyle(color: kPrimaryColor),
                              )
                            : const SizedBox(
                                height: 3,
                              ),
                        buildGlobalButton(
                            buttonPress: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();
                              if (result != null) {
                                PlatformFile file = result.files.first;
                                setState(() {
                                  signedContractPath = file.path.toString();
                                  signedContractName = file.name.toString();
                                  isContractSelected = true;
                                });
                                print(file.name);
                                print(file.path);
                              } else {
                                // User canceled the picker
                              }
                            },
                            buttonLabel: "Upload Signed Contract",
                            buttonColor: kPrimaryColor,
                            buttonTextColor: Colors.white),
                        isContractSelected == true
                            ? Text(
                                signedContractName!,
                                style: TextStyle(color: kPrimaryColor),
                              )
                            : const SizedBox(
                                height: 3,
                              ),
                        buildGlobalButton(
                            buttonPress: () {
                              setState(() {
                                isPinning = true;
                              });
                              getLocation();
                            },
                            buttonLabel: 'Pin current location',
                            buttonColor: kPrimaryColor,
                            buttonTextColor: Colors.white),
                        const SizedBox(
                          height: 10,
                        ),
                        isPinning == false
                            ? Text(
                                long + lat,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                              )
                            : SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  color: kPrimaryColor,
                                )),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            width: 100.w,
                            child: TextField(
                              onChanged: (value) => _checkPassword(value),
                              keyboardType: TextInputType.text,
                              enabled: true,
                              style: const TextStyle(color: Colors.black),
                              controller: registerPasswordController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.key,
                                  color: kPrimaryColor,
                                ),
                                border: const OutlineInputBorder(),
                                labelText: 'Password',
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
                          nameController: registerConfirmPasswordController,
                          title: 'Confirm Password',
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
                                  if (registerFullNameController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Full name field is required'),
                                      ),
                                    );
                                  } else if (registerEmailController
                                      .text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Email field is required'),
                                      ),
                                    );
                                  } else if (phoneNumberUser == "") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Phone number is required'),
                                      ),
                                    );
                                  } else if (registerLicenceNumberController
                                      .text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Licence Number is required'),
                                      ),
                                    );
                                  } else if (selectedIssueDateString == "") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Date of licence issue is required'),
                                      ),
                                    );
                                  } else if (selectedCategory == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Select a service category before proceeding'),
                                      ),
                                    );
                                  } else if (nationalIdPath == "") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Tap 'Upload national id' button to upload"),
                                      ),
                                    );
                                  } else if (signedContractPath == "") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Tap 'Upload signed contract' button to upload"),
                                      ),
                                    );
                                  } else if (long.isEmpty && lat.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Tap 'Pin current location' button to set your location"),
                                      ),
                                    );
                                  } else if (registerPasswordController
                                      .text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Password field is required"),
                                      ),
                                    );
                                  } else if (registerPasswordController
                                          .text.length <
                                      6) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Password length is too short"),
                                      ),
                                    );
                                  } else if (registerConfirmPasswordController
                                      .text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Confirm password field is required"),
                                      ),
                                    );
                                  } else if (registerConfirmPasswordController
                                          .text !=
                                      registerPasswordController.text) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Both passwords should match"),
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    registerHsp();
                                  }
                                },
                                buttonLabel: 'SIGN UP',
                                buttonColor: kPrimaryColor,
                                buttonTextColor: Colors.white)
                            : SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  color: kPrimaryColor,
                                )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Text(
                                  'By Signing in you agree with our',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  'Terms & Conditions',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                  )
                ]),
              )
            ])));
  }
}
