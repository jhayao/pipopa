import 'dart:async';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';

import '../models/travelHistoryModel.dart';
import 'data.dart';
import 'invoice.dart';


const examples = <Example>[

  Example('INVOICE', 'invoice.dart', generateInvoice,true),

];

typedef LayoutCallbackWithData = Future<Uint8List> Function(
    PdfPageFormat pageFormat, TravelHistoryModel data);

class Example {
  const Example(this.name, this.file, this.builder, [this.needsData = false]);

  final String name;

  final String file;

  final LayoutCallbackWithData builder;

  final bool needsData;
}