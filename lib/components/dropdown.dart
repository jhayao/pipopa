import 'dart:ffi';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unicons/unicons.dart';

import '../utils/constants.dart';

class Dropdown extends StatelessWidget {
  const Dropdown({
    Key? key,
    required this.icon,
    required this.label,
    this.onChange,
    required this.widthSize,
    required this.icon2,
    required this.label2,
    this.onChange2,
  }) : super(key: key);

  final Icon icon;
  final String label;
  final Function? onChange;
  final Icon icon2;
  final String label2;
  final Function? onChange2;
  final int widthSize;

  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    var dropdownvalue = 'Gender'.obs;
    var items = [
      'Gender',
      'Male',
      'Female',
    ];
    var dateValue = 'Birthday'.obs;
    // var items =
    // String dropdownvalue = 'Gender';
    return Row(children: <Widget>[
      Expanded(
        flex: 20,
        child: Container(
            margin: EdgeInsets.only(top: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: constants.radousNormal,
            ),
            width: Get.width / 3 - 20,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Obx(
              () => Column(
                children: [
                  DropdownButton(
                    // Initial Value
                    value: dropdownvalue.value,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      dropdownvalue.value = newValue!;
                      if (onChange != null) onChange!(newValue);
                    },
                  ),
                ],
              ),
            )),
      ),
      Expanded(
        flex: 30,
        child: Container(
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: constants.radousNormal,
          ),
          width: Get.width / 3 - 20,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              DateTimePicker(
                type: DateTimePickerType.date,
                dateMask: 'd MMM, yyyy',
                initialValue: DateTime.now().toString(),
                firstDate: DateTime(1950),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Birthday',
                selectableDayPredicate: (date) {
                  // Disable weekend days to select from the calendar
                  // if (date.weekday == 6 || date.weekday == 7) {
                  //   return false;
                  // }

                  return true;
                },
                onChanged: (val) {if (onChange2 != null) onChange2!(val);},
                validator: (val) {
                  print(val);
                  return null;
                },
                onSaved: (val) => print(val),
              ),
              // TextFormField(
              //   onTap: () {
              //     print("Tap");
              //   },
              //   decoration: InputDecoration(
              //     icon: Icon(Icons.calendar_month),
              //     hintText: 'Birthday',
              //     border: InputBorder.none,
              //   ),
              //   enabled: true,
              //   keyboardType: TextInputType.name,
              //   onChanged: (val) {
              //     // if (onChange1 != null) onChange1!(val);
              //   },
              // ),
            ],
          ),
        ),
      ),
    ]);
  }
}
