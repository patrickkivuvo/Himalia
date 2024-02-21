import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

late SharedPreferences sharedPref;

class Helpers {
  static String getParamDateFormat(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  static TimeOfDay timeOfTheDayFromString(String string) {
    TimeOfDay results = TimeOfDay(
        hour: int.parse(string.split(":")[0]),
        minute: int.parse(string.split(":")[1]));
    return results;
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}

refreshAccessToken(
    {required navigation, required failedNavigation, required message}) async {
  sharedPref = await SharedPreferences.getInstance();

  var token = sharedPref.getString('refresh_token') ?? "";
  var request = http.MultipartRequest(
      'POST', Uri.parse('$accountsBaseUrl/token/refresh/'));
  request.fields.addAll({'refresh': token});

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var data = jsonDecode(await response.stream.bytesToString());
    var pref = await SharedPreferences.getInstance();
    pref.setString("access_token", data['access']);
    navigation;
  } else {
    print(response.reasonPhrase);
    failedNavigation;
    message;
  }
}
