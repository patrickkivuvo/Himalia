// ignore_for_file: unused_field

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:himalia/screens/profile/widgets/availability.dart';
import 'package:himalia/screens/teleconference_appointment/view_teleconference_appointment.dart';
import 'package:sizer/sizer.dart';
import '../../utils/constants.dart';
import '../../utils/widgets.dart';
import '../symptom_checker_recommendations/recommendation_requests.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController phoneNumber =
      TextEditingController(text: mobileNumber ?? "");
  late TextEditingController aboutMeController =
      TextEditingController(text: aboutInfo ?? "");
  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 15);
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  List myTimeSlots = [
    "7:15 AM-8:30 AM",
    "9:15 AM-10:30 AM",
    "11:15 AM-1:30 PM",
    "3:15 PM-4:30 PM",
    "5:15 PM-6:30 PM",
  ];
  String? selectedQualification;
  String? selectedSpecialization;
  String? selectedSubSpecialization;
  String? selectedDay;
  String? mobileNumber = "1234567890"; // Static data for demonstration
  String? fullName = "John Doe"; // Static data for demonstration
  String? dayKey;
  String? licenseNo;
  bool isLoading = false;
  String? speciality = "Dermatologist"; // Static data for demonstration
  String? dateOfLicenseIssue;
  String? aboutInfo = "Lorem ipsum"; // Static data for demonstration
  String? profilePicture;
  String imagePath = "";
  String? imageName;
  String? emailAddress =
      "john.doe@example.com"; // Static data for demonstration
  List allAvailableTimes = [];
  bool isEditting = false;
  bool isUploading = false;
  bool isSelectedMonday = false;
  bool isSelectedTuesday = false;
  bool isSelectedWednesday = false;
  bool isSelectedThursday = false;
  bool isSelectedFriday = false;
  bool isSelectedSaturday = false;
  bool isSelectedSunday = false;
  bool isPosting = false;
  bool isGettingAvailabilities = false;

  final List<String> qualificationList = [
    'Dermatologist',
    'Pediatrician',
    'Physiotherapist',
  ];
  final List<String> specializationList = [
    'Specialization 1',
    'Specialization 2',
    'Specialization 3'
  ];
  final List<String> subSpecializationList = [
    'Sub-specialization 1',
    'Sub-specialization 2',
    'Sub-specialization 3'
  ];

  List menu = ["Recommendations", "My\nAppointments", "Logout "];
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _selectStartTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        _startTime = newTime;
      });
    }
  }

  void _selectEndTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        _endTime = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'My Profile',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: kPrimaryColor),
              ),
              centerTitle: true,
            ),
            body: Column(children: [
              const SizedBox(
                height: 50,
              ),
              // Display Profile Picture
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kPrimaryColor),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Colors.white],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: imagePath == ""
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "Upload\n Profile",
                                  style: TextStyle(color: kPrimaryColor),
                                ),
                              ),
                            )
                          : Image.file(
                              File(imagePath),
                              height: 100,
                              width: 100,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ),
              ),
              // Display Edit Profile Picture Button
              imagePath != ""
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 70.w,
                        child: buildGlobalButton(
                          buttonPress: () {
                            // Implement your edit profile picture logic here
                          },
                          buttonLabel: 'Edit Profile Picture',
                          buttonColor: kPrimaryColor,
                          buttonTextColor: kBackgroundColor,
                        ),
                      ),
                    )
                  : const SizedBox(),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 60,
                      margin: const EdgeInsets.only(left: 60),
                      child: TabBar(
                        tabs: [
                          Container(
                            child: const Text(
                              'Basic Info',
                            ),
                          ),
                          Container(
                            child: const Text(
                              'Availability',
                            ),
                          ),
                          Container(
                            child: const Text(
                              'Menu',
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
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  fullName ?? "",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w700),
                                ),
                                leading: Icon(
                                  Icons.account_circle,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  emailAddress ?? "",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w700),
                                ),
                                leading: Icon(
                                  Icons.email,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  speciality ?? "",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w700),
                                ),
                                leading: Icon(
                                  Icons.ac_unit_rounded,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            buildGlobalTextField(
                              nameController: phoneNumber,
                              title: 'Phone Number',
                              textInputColor: Colors.black,
                              borderColor: kPrimaryColor,
                              labelColor: kPrimaryColor,
                              textInput: TextInputType.text,
                              isEnabled: true,
                              leadingIcon: Icon(
                                Icons.phone,
                                color: kPrimaryColor,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildExpandableTextField(
                                  textFieldController: aboutMeController,
                                  fieldText: 'About me'),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            isEditting == false
                                ? buildGlobalButton(
                                    buttonPress: () {
                                      setState(() {
                                        isEditting = true;
                                      });
                                      // editHspDetails();
                                    },
                                    buttonLabel: "Edit Profile",
                                    buttonColor: kPrimaryColor,
                                    buttonTextColor: Colors.white)
                                : SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                    const Availability(),
                    SingleChildScrollView(
                      child: Container(
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: menu.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                if (index == 0) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const RecommendationRequests(),
                                    ),
                                  );
                                } else if (index == 1) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const TeleconferenceAppointments(),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(color: kPrimaryColor),
                                ),
                                child: Center(
                                  child: Text(
                                    menu[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ])));
  }
}
