/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:math';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/travelHistoryModel.dart';
import 'data.dart';

Future<Uint8List> generateReport(
    PdfPageFormat pageFormat, List<TravelHistoryModel> data) async {
  const tableHeaders = ['Count', 'From', 'To', 'Fare'];

  var dataTable = [


  ];


  for (var x in data)
  {
    List<Object> obj = [];
    obj.add(x.passenger!.name.toString());
    obj.add(x.startPoint!.displayName.toString());
    obj.add(x.endPoint!.displayName.toString());
    dataTable.add(obj);
  }

  final expense = dataTable
      .map((e) => e[2] as num)
      .reduce((value, element) => value + element);

  const baseColor = PdfColors.cyan;

  // Create a PDF document.
  final document = pw.Document();

  final theme = pw.ThemeData.withFont(
    base: await PdfGoogleFonts.openSansRegular(),
    bold: await PdfGoogleFonts.openSansBold(),
  );



  // Top bar chart
  final chart1 = pw.Chart(
    left: pw.Container(
      alignment: pw.Alignment.topCenter,
      margin: const pw.EdgeInsets.only(right: 5, top: 10),
      child: pw.Transform.rotateBox(
        angle: pi / 2,
        child: pw.Text('Amount'),
      ),
    ),
    overlay: pw.ChartLegend(
      position: const pw.Alignment(-.7, 1),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(
          color: PdfColors.black,
          width: .5,
        ),
      ),
    ),
    grid: pw.CartesianGrid(
      xAxis: pw.FixedAxis.fromStrings(
        List<String>.generate(
            dataTable.length, (index) => dataTable[index][0] as String),
        marginStart: 30,
        marginEnd: 30,
        ticks: true,
      ),
      yAxis: pw.FixedAxis(
        [0, 100, 200, 300, 400, 500, 600, 700],
        format: (v) => '\$$v',
        divisions: true,
      ),
    ),
    datasets: [
      pw.BarDataSet(
        color: PdfColors.blue100,
        legend: tableHeaders[2],
        width: 15,
        offset: -10,
        borderColor: baseColor,
        data: List<pw.PointChartValue>.generate(
          dataTable.length,
              (i) {
            final v = dataTable[i][2] as num;
            return pw.PointChartValue(i.toDouble(), v.toDouble());
          },
        ),
      ),
      pw.BarDataSet(
        color: PdfColors.amber100,
        legend: tableHeaders[1],
        width: 15,
        offset: 10,
        borderColor: PdfColors.amber,
        data: List<pw.PointChartValue>.generate(
          dataTable.length,
              (i) {
            final v = dataTable[i][1] as num;
            return pw.PointChartValue(i.toDouble(), v.toDouble());
          },
        ),
      ),
    ],
  );

  // Left curved line chart
  final chart2 = pw.Chart(
    right: pw.ChartLegend(),
    grid: pw.CartesianGrid(
      xAxis: pw.FixedAxis([0, 1, 2, 3, 4, 5, 6]),
      yAxis: pw.FixedAxis(
        [0, 200, 400, 600],
        divisions: true,
      ),
    ),
    datasets: [
      pw.LineDataSet(
        legend: 'Expense',
        drawSurface: true,
        isCurved: true,
        drawPoints: false,
        color: baseColor,
        data: List<pw.PointChartValue>.generate(
          dataTable.length,
              (i) {
            final v = dataTable[i][2] as num;
            return pw.PointChartValue(i.toDouble(), v.toDouble());
          },
        ),
      ),
    ],
  );

  // Data table
  final table = pw.Table.fromTextArray(
    border: null,
    headers: tableHeaders,
    data: List<List<dynamic>>.generate(
      dataTable.length,
          (index) => <dynamic>[
        dataTable[index][0],
        dataTable[index][1],
        dataTable[index][2],
        (dataTable[index][1] as num) - (dataTable[index][2] as num),
      ],
    ),
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontWeight: pw.FontWeight.bold,
    ),
    headerDecoration: const pw.BoxDecoration(
      color: baseColor,
    ),
    rowDecoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          color: baseColor,
          width: .5,
        ),
      ),
    ),
    cellAlignment: pw.Alignment.centerRight,
    cellAlignments: {0: pw.Alignment.centerLeft},
  );

  // Add page to the PDF


  // Second page with a pie chart
  document.addPage(
    pw.Page(
      pageFormat: pageFormat,
      theme: theme,
      build: (context) {
        const chartColors = [
          PdfColors.blue300,
          PdfColors.green300,
          PdfColors.amber300,
          PdfColors.pink300,
          PdfColors.cyan300,
          PdfColors.purple300,
          PdfColors.lime300,
        ];

        return pw.Column(
          children: [
            pw.Text('Budget Report',
                style: const pw.TextStyle(
                  color: baseColor,
                  fontSize: 40,
                )),
            pw.SizedBox(height: 10),
            pw.Flexible(
              child: pw.Chart(
                title: pw.Text(
                  'Booking breakdown',
                  style: const pw.TextStyle(
                    color: baseColor,
                    fontSize: 20,
                  ),
                ),
                grid: pw.PieGrid(),
                datasets: List<pw.Dataset>.generate(dataTable.length, (index) {
                  final data = dataTable[index];
                  final color = chartColors[index % chartColors.length];
                  final value = (data[2] as num).toDouble();
                  final pct = (value / expense * 100).round();
                  return pw.PieDataSet(
                    legend: '${data[0]}\n$pct%',
                    value: value,
                    color: color,
                    legendStyle: const pw.TextStyle(fontSize: 10),
                  );
                }),
              ),
            ),
            table,
          ],
        );
      },
    ),
  );

  // Return the PDF file content
  return document.save();
}