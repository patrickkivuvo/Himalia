import 'package:flutter/material.dart';
import 'package:himalia/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

Widget buildGlobalTextField(
    {required nameController,
    required title,
    required textInputColor,
    required borderColor,
    required labelColor,
    required textInput,
    required leadingIcon,
    required isEnabled}) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: SizedBox(
      width: 100.w,
      child: TextField(
        keyboardType: textInput,
        enabled: isEnabled,
        style: TextStyle(color: textInputColor),
        controller: nameController,
        decoration: InputDecoration(
          prefixIcon: leadingIcon,
          border: const OutlineInputBorder(),
          labelText: title,
          labelStyle: TextStyle(color: labelColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: borderColor,
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
  );
}

Widget buildGlobalButton(
    {required buttonPress,
    required buttonLabel,
    required buttonColor,
    required buttonTextColor}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: InkWell(
      onTap: buttonPress,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [buttonColor, buttonColor],
          ),
        ),
        width: double.infinity,
        height: 50,
        child: Center(
          child: Text(
            buttonLabel,
            style: TextStyle(
              color: buttonTextColor,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget buildDropDownButton(
    {required pickedValue,
    required onTapped,
    required dropDownTitle,
    required buttonIcon,
    required onChanged,
    required List itemList}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Row(
            children: [
              Icon(
                buttonIcon,
                size: 16,
                color: kPrimaryColor,
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  dropDownTitle,
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
          items: itemList
              .map((item) => DropdownMenuItem<String>(
                    onTap: onTapped,
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: pickedValue,
          onChanged: onChanged,
          icon: const Icon(
            Icons.arrow_forward_ios_outlined,
          ),
          iconSize: 14,
          iconEnabledColor: kPrimaryColor,
          iconDisabledColor: Colors.grey,
          buttonHeight: 50,
          buttonWidth: 100.w,
          buttonPadding: const EdgeInsets.only(left: 14, right: 14),
          buttonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: kPrimaryColor,
              ),
              color: Colors.white),
          buttonElevation: 2,
          itemHeight: 40,
          itemPadding: const EdgeInsets.only(left: 14, right: 14),
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
  );
}

Widget buildExpandableTextField(
    {required textFieldController, required fieldText}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: double.infinity,
      child: TextField(
        controller: textFieldController,
        decoration: InputDecoration(
          hintText: fieldText,
          labelText: fieldText,
          labelStyle: TextStyle(color: kPrimaryColor),
          hintStyle: TextStyle(color: kPrimaryColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: kPrimaryColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: kPrimaryColor,
            ),
          ),
        ),
        autofocus: false,
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
    ),
  );
}

Widget buildDaysContainer(
    {required day,
    required onTapp,
    required containerColor,
    required labelColor}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: onTapp,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kPrimaryColor),
            color: containerColor),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(day,
              style: TextStyle(
                  color: labelColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20)),
        )),
      ),
    ),
  );
}

Widget buildSelectedTimeContainer({required time, required buttonTapped}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: buttonTapped,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kPrimaryColor),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.white],
          ),
        ),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(time,
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.w700,
              )),
        )),
      ),
    ),
  );
}
