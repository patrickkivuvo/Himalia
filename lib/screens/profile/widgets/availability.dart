import 'package:flutter/material.dart';
import 'package:himalia/screens/profile/availability_details.dart';
import 'package:himalia/utils/constants.dart';
import 'package:himalia/utils/widgets.dart';
import 'package:sizer/sizer.dart';

class Availability extends StatefulWidget {
  const Availability({super.key});

  @override
  _AvailabilityState createState() => _AvailabilityState();
}

class _AvailabilityState extends State<Availability> {
  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 15);
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  List<String> myTimeSlots = [
    "7:15 AM-8:30 AM",
    "9:15 AM-10:30 AM",
    "11:15 AM-1:30 PM",
    "3:15 PM-4:30 PM",
    "5:15 PM-6:30 PM",
  ];
  String? selectedDay;
  bool isLoading = true;
  bool isPosting = false;

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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  'Click on a day to view your available time slots',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                child: Row(
                  children: days.map((day) {
                    return buildDaysContainer(
                      day: day.substring(0, 3),
                      onTapp: () {
                        setState(() {
                          selectedDay = day;
                        });
                      },
                      containerColor:
                          selectedDay == day ? kPrimaryColor : Colors.white,
                      labelColor:
                          selectedDay == day ? Colors.white : kPrimaryColor,
                    );
                  }).toList(),
                ),
              ),
            ),
            selectedDay != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          GridView.builder(
                            itemCount: myTimeSlots.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    color: const Color(0xff5c3e84),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          myTimeSlots[index],
                                          style: const TextStyle(
                                            color: Color(0xff5c3e84),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 60,
                                      child: buildGlobalButton(
                                        buttonPress: () {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  AvailabilityDetails(
                                                availabilityID:
                                                    index.toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        buttonLabel: "View Details",
                                        buttonColor: kPrimaryColor,
                                        buttonTextColor: kBackgroundColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: (.2 / .2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  'Add available slot(s)',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 40.w,
                      child: buildDropDownButton(
                        pickedValue: selectedDay,
                        onChanged: (value) {
                          setState(() {
                            selectedDay = value as String;
                          });
                        },
                        itemList: days,
                        dropDownTitle: 'Select Day',
                        buttonIcon: Icons.sunny,
                        onTapped: () {
                          setState(() {});
                        },
                      ),
                    ),
                    buildSelectedTimeContainer(
                      time: _startTime == null
                          ? "Select Start Time"
                          : _startTime!.format(context),
                      buttonTapped: () {
                        _selectStartTime();
                      },
                    ),
                    buildSelectedTimeContainer(
                      time: _endTime == null
                          ? "Select End Time"
                          : _endTime!.format(context),
                      buttonTapped: () {
                        _selectEndTime();
                      },
                    ),
                  ],
                ),
              ),
            ),
            isPosting == false
                ? buildGlobalButton(
                    buttonPress: () {
                      if (selectedDay!.isNotEmpty &&
                          _endTime != null &&
                          _startTime != null) {
                        setState(() {
                          isPosting = true;
                        });
                        // Simulate posting action
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            isPosting = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Saved successfully"),
                            ),
                          );
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Select day and time before proceeding"),
                          ),
                        );
                      }
                    },
                    buttonLabel: 'Save',
                    buttonColor: kPrimaryColor,
                    buttonTextColor: Colors.white,
                  )
                : SizedBox(
                    height: 30,
                    width: 30,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
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
}
