import 'dart:async';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';

import '../models/travelHistoryModel.dart';
import 'data.dart';
import 'report2.dart';


const reports = <ReportPage>[

  ReportPage('REPORT', 'report2.dart', generateReport2),

];

typedef LayoutCallbackWithData = Future<Uint8List> Function(
    PdfPageFormat pageFormat, List<TravelHistoryModel> data);

class ReportPage {
  const ReportPage(this.name, this.file, this.builder, [this.needsData = false]);

  final String name;

  final String file;

  final LayoutCallbackWithData builder;

  final bool needsData;
}