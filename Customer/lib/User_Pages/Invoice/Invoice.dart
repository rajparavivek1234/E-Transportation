import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:myproject/All_User_Pages/Login_Page/Login_Page.dart';
import 'package:myproject/All_User_Pages/SignUp/SignUp.dart';
import 'package:myproject/User_Pages/Map/Map_Screen.dart';
import 'package:myproject/User_Pages/Payment/Payment.dart';
import 'package:myproject/User_Pages/SelectVehicle/VehicleDetails.dart';
import 'package:myproject/User_Pages/User_Details/User_Details.dart';
import 'file_handle_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

var now = new DateTime.now();
var formatter = new DateFormat('dd-MM-yyyy');
String date = now.day.toString() +
    " " +
    MONTHS[now.month - 1] +
    " " +
    now.year.toString() +
    ", " +
    now.hour.toString() +
    ":" +
    now.minute.toString() +
    ":" +
    now.second.toString();
var MONTHS = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];

class PdfInvoiceApi {
  static Future<File> generate() async {
    var finalprice = TotalPrice + TotalPrice * 0.18;
    final pdf = pw.Document();

    final iconImage = (await rootBundle
            .load('Assets/Images/InvoiceImage/E Transportation.png'))
        .buffer
        .asUint8List();
    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.Row(
              children: [
                pw.Image(
                  pw.MemoryImage(iconImage),
                  height: 60,
                  width: 60,
                ),
                pw.SizedBox(width: 5 * PdfPageFormat.mm),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        fontSize: 17.0,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'E-Transporation',
                      style: const pw.TextStyle(
                        fontSize: 15.0,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pw.Spacer(),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Customer Name:${FN} ${LN}",
                      style: pw.TextStyle(
                        fontSize: 15.5,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Customer Email:${EMAIL}',
                    ),
                    pw.Text(
                      "${date}",
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Divider(),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Text(
              "Starting point:${source}\n",
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Text(
              "Destination point:${Destination}\n",
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Text(
              "Price/KM:${PricePerKM}\n",
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Text(
              "Distance:${Distance}\n",
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Text(
              "Driver Name:${DriverName}",
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Text(
              "Vehicle Name:${VehicleName}",
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Text(
              "Vehicle No:${VehicleNo}",
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Divider(),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Row(
                children: [
                  pw.Spacer(flex: 6),
                  pw.Expanded(
                    flex: 4,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                "Total price",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Text(
                              "${TotalPrice.toStringAsFixed(2)}",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                'tax',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Text(
                              '18%',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.Divider(),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                'Total amount',
                                style: pw.TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Text(
                              "${finalprice.toString()}",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 2 * PdfPageFormat.mm),
                        pw.Container(height: 1, color: PdfColors.grey400),
                        pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
                        pw.Container(height: 1, color: PdfColors.grey400),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        footer: (context) {
          return pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Divider(),
              pw.SizedBox(height: 2 * PdfPageFormat.mm),
              pw.Text(
                'E-Trasporation',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Address: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    '602,Krishna Crown College Road,Nadiad',
                  ),
                ],
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Email: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'E-Trasporation111@gmail.com',
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return FileHandleApi.saveDocument(
        name: 'E-Trasnporation(Invoice).pdf', pdf: pdf);
  }
}
