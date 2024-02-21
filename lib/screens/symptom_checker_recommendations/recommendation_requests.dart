import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:himalia/screens/profile/profile_screen.dart';
import 'package:himalia/screens/symptom_checker_recommendations/recommendation_details.dart';
import 'package:himalia/utils/constants.dart';
import 'package:himalia/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class RecommendationRequests extends StatefulWidget {
  const RecommendationRequests({Key? key}) : super(key: key);

  @override
  State<RecommendationRequests> createState() => _RecommendationRequestsState();
}

class _RecommendationRequestsState extends State<RecommendationRequests> {
  late SharedPreferences sharedPref;
  List allAppointments = [];
  bool isLoading = true;

  // Simulated function to get appointments
  void getSymptomCheckerAppointments() {
    // Simulated list of appointments
    List simulatedAppointments = [
      {
        'id': 1,
        'symptoms': ['Fever', 'Cough'],
        'additional_info': 'Some additional information',
        'created_at': '2024-02-20T10:00:00',
        'is_session_ended': false,
      },
      {
        'id': 2,
        'symptoms': ['Headache', 'Sore throat'],
        'additional_info': 'Additional details here',
        'created_at': '2024-02-19T09:30:00',
        'is_session_ended': true,
      },
    ];

    setState(() {
      allAppointments = simulatedAppointments;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getSymptomCheckerAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const ProfileScreen()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            "Symptom Checker Appointments Requests",
            style: TextStyle(color: HexColor('#fefff1'), fontSize: 15),
          ),
        ),
        body: Container(
          child: isLoading == false
              ? allAppointments.isNotEmpty
                  ? ListView.builder(
                      itemCount: allAppointments.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SymptomCheckerAppointmentDetails(
                                      listOfSymptoms: allAppointments[index]
                                          ['symptoms'],
                                      additionalInformation:
                                          allAppointments[index]
                                              ['additional_info'],
                                      datePosted: Helpers.getParamDateFormat(
                                          DateTime.parse(allAppointments[index]
                                              ['created_at'])),
                                      appointmentID: allAppointments[index]
                                              ['id']
                                          .toString(),
                                    ),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                backgroundColor: kPrimaryColor,
                                child: const Icon(
                                  Icons.lightbulb_sharp,
                                  color: Colors.yellow,
                                ),
                              ),
                              title: Text(
                                "Appointment ID :${allAppointments[index]['id'].toString()}  ",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                "Date : ${Helpers.getParamDateFormat(DateTime.parse(allAppointments[index]['created_at']))} | Session Status: ${allAppointments[index]["is_session_ended"] == false ? "Pending" : "Completed"}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            )
                          ],
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "You have not booked any appointments.",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    )
              : SizedBox(
                  height: 60.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
