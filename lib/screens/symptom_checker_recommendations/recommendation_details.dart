import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:himalia/screens/symptom_checker_recommendations/recommendation_requests.dart';
import 'package:himalia/utils/widgets.dart';
import 'package:sizer/sizer.dart';
import '../../utils/constants.dart';

class SymptomCheckerAppointmentDetails extends StatefulWidget {
  final List listOfSymptoms;
  final String additionalInformation;
  final String datePosted;
  final String appointmentID;
  const SymptomCheckerAppointmentDetails(
      {Key? key,
      required this.listOfSymptoms,
      required this.additionalInformation,
      required this.datePosted,
      required this.appointmentID})
      : super(key: key);

  @override
  State<SymptomCheckerAppointmentDetails> createState() =>
      _SymptomCheckerAppointmentDetailsState();
}

class _SymptomCheckerAppointmentDetailsState
    extends State<SymptomCheckerAppointmentDetails> {
  List allRecommendations = [];
  bool isLoading = false;
  bool isPosting = false;
  TextEditingController recommendationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const RecommendationRequests()));
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Text(
              "Appointment Details",
              style: TextStyle(color: HexColor('#fefff1'), fontSize: 15),
            ),
          ),
          body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Container(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: kPrimaryColor,
                    child: ListTile(
                      title: Center(
                        child: Text(
                          "Symptom Checker Report | Report ID: ${widget.appointmentID}",
                          style: TextStyle(
                              color: kBackgroundColor,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Center(
                            child: Text(
                              "Associated Symptoms",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var i = 0;
                                i < widget.listOfSymptoms.length;
                                i++)
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "★ ${widget.listOfSymptoms[i]}",
                                    style: const TextStyle(color: Colors.black),
                                  )),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        ListTile(
                          title: Center(
                            child: Text(
                              "Additional Information",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.additionalInformation),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        ListTile(
                          title: Center(
                            child: Text(
                              "Recommendation You Posted Earlier",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: isLoading == false
                              ? allRecommendations.isNotEmpty
                                  ? ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: allRecommendations.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "✓ ${allRecommendations[index]}",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      })
                                  : Center(
                                      child: Text(
                                        "No recommendations yet.",
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildExpandableTextField(
                              textFieldController: recommendationController,
                              fieldText: 'Enter Recommendation'),
                        ),
                        isPosting == false
                            ? buildGlobalButton(
                                buttonPress: () {
                                  setState(() {
                                    isPosting = true;
                                    allRecommendations
                                        .add(recommendationController.text);
                                    recommendationController.clear();
                                  });
                                },
                                buttonLabel: "Post Recommendation",
                                buttonColor: kPrimaryColor,
                                buttonTextColor: kBackgroundColor)
                            : SizedBox(
                                height: 30,
                                width: 30,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: kPrimaryColor,
                                  ),
                                ))
                      ],
                    ),
                  ),
                ],
              ),
            )),
          )),
    );
  }
}
