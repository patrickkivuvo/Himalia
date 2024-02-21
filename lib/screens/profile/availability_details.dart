import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:himalia/screens/profile/profile_screen.dart';
import 'package:himalia/utils/constants.dart';
import 'package:himalia/utils/widgets.dart';
import 'package:sizer/sizer.dart';

class AvailabilityDetails extends StatefulWidget {
  final String availabilityID;
  const AvailabilityDetails({Key? key, required this.availabilityID})
      : super(key: key);

  @override
  State<AvailabilityDetails> createState() => _AvailabilityDetailsState();
}

class _AvailabilityDetailsState extends State<AvailabilityDetails> {
  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 15);
  String? selectedDay;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? activeStatus;
  bool isLoading = false;
  bool isDeleting = false;
  bool isFetching = true;

  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final List<String> status = ['Active', 'Inactive'];

  void getAvailabilityById() {
    // Mocking data
    selectedDay = 'Monday';
    _startTime = const TimeOfDay(hour: 9, minute: 0);
    _endTime = const TimeOfDay(hour: 17, minute: 0);
    activeStatus = 'Active';

    setState(() {
      isFetching = false;
    });
  }

  void deleteAvailability() {
    // Mocking delete action
    print('Deleting availability...');
    // Mocking a successful delete action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Deleted successfully "),
      ),
    );
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ProfileScreen()));
    setState(() {
      isDeleting = false;
    });
  }

  void editAvailability() {
    // Mocking edit action
    print('Editing availability...');
    // Mocking a successful edit action
    setState(() {
      isLoading = false;
    });
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
  void initState() {
    super.initState();
    getAvailabilityById();
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
          centerTitle: true,
          backgroundColor: Colors.blue, // Changed color for demo
          title: Text(
            "Availability Details",
            style: TextStyle(color: HexColor('#fefff1'), fontSize: 15),
          ),
        ),
        body: Container(
          child: isFetching == false
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          SizedBox(
                            width: 100.w,
                            child: Text(
                              selectedDay ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            width: 100.w,
                            child: TextButton(
                              onPressed: () {
                                _selectStartTime();
                              },
                              child: Text(
                                _startTime == null
                                    ? "Select Start Time"
                                    : "From :${_startTime!.format(context)}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100.w,
                            child: TextButton(
                              onPressed: () {
                                _selectEndTime();
                              },
                              child: Text(
                                _endTime == null
                                    ? "Select End Time"
                                    : "To :${_endTime!.format(context)}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100.w,
                            child: DropdownButton<String>(
                              value: activeStatus,
                              onChanged: (value) {
                                setState(() {
                                  activeStatus = value;
                                });
                              },
                              items: status.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          isLoading == false
                              ? SizedBox(
                                  width: 100.w,
                                  child: buildGlobalButton(
                                      buttonPress: () {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        if (activeStatus!.isEmpty) {
                                          setState(() {
                                            activeStatus = "Active";
                                          });
                                        }

                                        editAvailability();
                                      },
                                      buttonLabel: 'Edit',
                                      buttonColor: kPrimaryColor,
                                      buttonTextColor: kBackgroundColor),
                                )
                              : SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    color: kPrimaryColor,
                                  )),
                          isDeleting == false
                              ? SizedBox(
                                  width: 100.w,
                                  child: buildGlobalButton(
                                      buttonPress: () {
                                        setState(() {
                                          isDeleting = true;
                                        });
                                        deleteAvailability();
                                      },
                                      buttonLabel: 'Delete',
                                      buttonColor: Colors.red,
                                      buttonTextColor: kBackgroundColor),
                                )
                              : const SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
