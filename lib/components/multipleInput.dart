import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

import '../utils/constants.dart';

class MultipleInput extends StatelessWidget {
  const MultipleInput({
    Key? key,
    this.onChange1,
    this.onChange2,
    required this.icon1,
    required this.label1,
    required this.icon2,
    required this.label2, required this.label3, this.onChange3,
  }) : super(key: key);

  final Icon icon1;
  final String label1;
  final Icon icon2;
  final String label2;
  final String label3;
  final Function? onChange1;
  final Function? onChange2;
  final Function? onChange3;
  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    return Row(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 30,
                  child: Container(
                    margin: EdgeInsets.only(top: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: constants.radousNormal,
                    ),
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            icon: icon1,
                            hintText: label1,
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.name,
                          onChanged: (val) {
                            if (onChange1 != null) onChange1!(val);
                          },
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 30,
                  child: Container(
                    margin: EdgeInsets.only(top: 20,right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: constants.radousNormal,
                    ),
                    width: Get.width ,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            icon: icon2,
                            hintText: label2,
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.name,
                          onChanged: (val) {
                            if (onChange2 != null) onChange2!(val);
                          },
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 10,
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: constants.radousNormal,
                    ),
                    width: Get.width ,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            // icon: icon2,
                            hintText: label3,
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.name,
                          onChanged: (val) {
                            if (onChange3 != null) onChange3!(val);
                          },

                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),


      ],
    );
  }
}
