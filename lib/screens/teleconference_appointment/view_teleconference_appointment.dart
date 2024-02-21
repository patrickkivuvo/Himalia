import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:himalia/screens/profile/profile_screen.dart';
import 'package:sizer/sizer.dart';
import '../../utils/constants.dart';

class TeleconferenceAppointments extends StatefulWidget {
  const TeleconferenceAppointments({Key? key}) : super(key: key);

  @override
  State<TeleconferenceAppointments> createState() =>
      _TeleconferenceAppointmentsState();
}

class _TeleconferenceAppointmentsState
    extends State<TeleconferenceAppointments> {
  List<Map<String, dynamic>> allAppointments = [];
  bool isLoading = true;

  // Mock data for appointments
  List<Map<String, dynamic>> mockAppointments = [
    {
      'type': 'Meeting',
      'start_time': '2024-02-21 09:00 AM',
      'end_time': '2024-02-21 10:00 AM'
    },
    {
      'type': 'Presentation',
      'start_time': '2024-02-22 02:00 PM',
      'end_time': '2024-02-22 03:00 PM'
    },
  ];

  @override
  void initState() {
    super.initState();
    // Simulate loading
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        allAppointments = mockAppointments;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
            (Route<dynamic> route) => false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            "My Teleconference Appointments",
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
                                // Handle onTap
                              },
                              leading: CircleAvatar(
                                backgroundColor: kPrimaryColor,
                                child: const Icon(
                                  Icons.lightbulb_sharp,
                                  color: Colors.yellow,
                                ),
                              ),
                              title: Text(
                                "Appointment Type :${allAppointments[index]['type']}  ",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w700),
                              ),
                              subtitle: Text(
                                "Start Time : ${allAppointments[index]['start_time']} | End Time: ${allAppointments[index]["end_time"]}",
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
                        "No booked appointments.",
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
