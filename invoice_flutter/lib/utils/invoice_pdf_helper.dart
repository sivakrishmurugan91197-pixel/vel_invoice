import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'number_to_words.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

Future<Uint8List> generateInvoicePdf(Map<String, dynamic> data) async {
  final pdf = pw.Document();

  // Parse fields
  final String companyName = data['companyName'] ?? '';
  final String panNo = data['panNo'] ?? '';
  final String gstin = data['gstin'] ?? '';
  final String phone = data['phone'] ?? '';
  final String address = data['address'] ?? '';
  final String invoiceNo = data['invoiceNo'] ?? '';
  final String invoiceDate = data['invoiceDate'] ?? '';
  final String dueDate = data['dueDate'] ?? '';
  final String motorVehicleNo = data['motorVehicleNo'] ?? '';
  final String billTo = data['billTo'] ?? '';
  final String shipTo = data['shipTo'] ?? '';
  final String placeOfSupply = data['placeOfSupply'] ?? '';
  final String jurisdiction = data['jurisdiction'] ?? '';
  final String terms = (data['terms'] ?? '').replaceAll('[ENTER_YOUR_CITY_NAME]', jurisdiction);
  
  final String bankName = data['bankName'] ?? '';
  final String bankAccNo = data['bankAccNo'] ?? '';
  final String bankBranch = data['bankBranch'] ?? '';
  final String bankIfsc = data['bankIfsc'] ?? '';

  final List<dynamic> items = data['items'] ?? [];

  // Helper to format currency in Indian style
  String formatIndianNumber(double numVal) {
    if (numVal.isNaN) return "0.00";
    final isDecimal = numVal % 1 != 0;
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '',
      decimalDigits: isDecimal ? 2 : 0,
    );
    return formatter.format(numVal).trim();
  }

  // Calculations
  double totalQty = 0;
  double totalTaxable = 0;
  double totalTax = 0;
  double grandTotal = 0;

  final List<Map<String, dynamic>> calculatedItems = [];
  for (var item in items) {
    // Parse quantity - extract numeric part
    final String qtyStr = item['qty'] ?? '';
    final RegExp numRegExp = RegExp(r'^[\d\.]+');
    final String numMatch = numRegExp.firstMatch(qtyStr)?.group(0) ?? '0';
    final double qtyVal = double.tryParse(numMatch) ?? 0;
    final double rateVal = double.tryParse(item['rate']?.toString() ?? '0') ?? 0;
    final double taxRateVal = double.tryParse(item['taxRate']?.toString() ?? '5') ?? 0;

    final double taxable = qtyVal * rateVal;
    final double tax = taxable * (taxRateVal / 100);
    final double total = taxable + tax;

    totalQty += qtyVal;
    totalTaxable += taxable;
    totalTax += tax;
    grandTotal += total;

    calculatedItems.add({
      'description': item['description'] ?? '',
      'hsn': item['hsn'] ?? '',
      'qty': qtyStr,
      'rate': rateVal,
      'tax': tax,
      'taxRate': taxRateVal,
      'total': total,
    });
  }

  final double cgstAmount = totalTax / 2;
  final double sgstAmount = totalTax / 2;
  final double totalTaxRate = items.isNotEmpty ? (double.tryParse(items[0]['taxRate']?.toString() ?? '5') ?? 5) : 5;

  final String wordsAmount = convertNumberToWords(grandTotal).replaceAll(RegExp(r' Only$', caseSensitive: false), '');

  final fontRegular = await PdfGoogleFonts.notoSansRegular();
  final fontBold = await PdfGoogleFonts.notoSansBold();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      theme: pw.ThemeData.withFont(
        base: fontRegular,
        bold: fontBold,
      ),
      build: (pw.Context context) {
        return pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.symmetric(
              horizontal: const pw.BorderSide(color: PdfColor.fromInt(0xffd4af37), width: 3),
              vertical: const pw.BorderSide(color: PdfColor.fromInt(0xffd4af37), width: 1),
            ),
          ),
          padding: const pw.EdgeInsets.all(12),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Row
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          companyName.toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                            color: const PdfColor.fromInt(0xff162642),
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          "PAN No: $panNo    GSTIN: $gstin",
                          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey900),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          "Phone: $phone",
                          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey900),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          "Address: $address",
                          style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey800),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 10),
                  pw.Container(
                    width: 70,
                    height: 70,
                    alignment: pw.Alignment.center,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: const PdfColor.fromInt(0xfff2e3c6)),
                    ),
                    child: pw.Text(
                      "TAX INVOICE",
                      style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Divider(color: const PdfColor.fromInt(0xfff2e3c6), thickness: 1.5),

              // Meta Row
              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("INVOICE NO.", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                        pw.Text(invoiceNo, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("INVOICE DATE", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                        pw.Text(invoiceDate, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("MOTOR VEHICLE NO", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                        pw.Text(motorVehicleNo, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Divider(color: const PdfColor.fromInt(0xfff2e3c6), thickness: 1.5),

              // Billing & Shipping Row
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("BILL TO", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xff162642))),
                        pw.SizedBox(height: 4),
                        pw.Text(billTo, style: const pw.TextStyle(fontSize: 9)),
                        pw.SizedBox(height: 4),
                        pw.Text("Place of Supply: $placeOfSupply", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 15),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("SHIP TO", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xff162642))),
                        pw.SizedBox(height: 4),
                        pw.Text(shipTo, style: const pw.TextStyle(fontSize: 9)),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              // Items Table
              pw.Table(
                border: pw.TableBorder.all(color: const PdfColor.fromInt(0xfff2e3c6), width: 1),
                columnWidths: {
                  0: const pw.FixedColumnWidth(25),
                  1: const pw.FlexColumnWidth(3),
                  2: const pw.FixedColumnWidth(60),
                  3: const pw.FixedColumnWidth(40),
                  4: const pw.FixedColumnWidth(60),
                  5: const pw.FixedColumnWidth(65),
                  6: const pw.FixedColumnWidth(70),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xff162642)),
                    children: [
                      pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text("No", style: pw.TextStyle(color: PdfColors.white, fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
                      pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text("Items", style: pw.TextStyle(color: PdfColors.white, fontSize: 9, fontWeight: pw.FontWeight.bold))),
                      pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text("HSN No.", style: pw.TextStyle(color: PdfColors.white, fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
                      pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text("Qty.", style: pw.TextStyle(color: PdfColors.white, fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
                      pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text("Rate", style: pw.TextStyle(color: PdfColors.white, fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
                      pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text("Tax", style: pw.TextStyle(color: PdfColors.white, fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
                      pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text("Total", style: pw.TextStyle(color: PdfColors.white, fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
                    ],
                  ),

                  // Item Rows
                  ...List.generate(calculatedItems.length, (idx) {
                    final item = calculatedItems[idx];
                    return pw.TableRow(
                      children: [
                        pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text("${idx + 1}", style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text(item['description'], style: const pw.TextStyle(fontSize: 8))),
                        pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text(item['hsn'], style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                        pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text(item['qty'], style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.right)),
                        pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text(formatIndianNumber(item['rate']), style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.right)),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(6), 
                          child: pw.Text(
                            "${formatIndianNumber(item['tax'])}\n(${item['taxRate']}%)", 
                            style: const pw.TextStyle(fontSize: 8), 
                            textAlign: pw.TextAlign.right
                          ),
                        ),
                        pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text(formatIndianNumber(item['total']), style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.right)),
                      ],
                    );
                  }),

                  // Padding Rows to make the invoice look professional (minimum 8 rows total)
                  ...List.generate(
                    (8 - calculatedItems.length) > 0 ? (8 - calculatedItems.length) : 0,
                    (index) => pw.TableRow(
                      children: List.generate(
                        7,
                        (cellIdx) => pw.Container(
                          padding: const pw.EdgeInsets.symmetric(vertical: 12),
                          child: pw.Text("", style: const pw.TextStyle(fontSize: 8)),
                        ),
                      ),
                    ),
                  ),

                  // Subtotal Row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xfffdfbf7)),
                    children: [
                      pw.Container(),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text("SUBTOTAL", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                        alignment: pw.Alignment.centerLeft,
                      ),
                      pw.Container(),
                      pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text(totalQty.toStringAsFixed(0), style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
                      pw.Container(),
                      pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text("₹ ${formatIndianNumber(totalTax)}", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
                      pw.Container(padding: const pw.EdgeInsets.all(6), child: pw.Text("₹ ${formatIndianNumber(grandTotal)}", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 12),

              // Footer Area
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Footer Left: Total Words and Bank Details
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Total Amount (in words)", style: pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700, fontWeight: pw.FontWeight.bold)),
                        pw.Text(wordsAmount, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xff162642))),
                        pw.SizedBox(height: 12),
                        
                        pw.Text("Bank Details:", style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                        pw.Text("A/c Name : $bankName", style: const pw.TextStyle(fontSize: 8)),
                        pw.Text("A/c No : $bankAccNo", style: const pw.TextStyle(fontSize: 8)),
                        pw.Text("Branch: $bankBranch", style: const pw.TextStyle(fontSize: 8)),
                        pw.Text("IFSC Code : $bankIfsc", style: const pw.TextStyle(fontSize: 8)),

                        pw.SizedBox(height: 12),
                        pw.Text("Terms & Conditions:", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                        pw.Text(terms, style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey800)),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 20),
                  // Footer Right: Summary & Signature
                  pw.Container(
                    width: 200,
                    child: pw.Column(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(6),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: const PdfColor.fromInt(0xfff2e3c6)),
                          ),
                          child: pw.Column(
                            children: [
                              _buildSummaryLine("Taxable Amount", "₹ ${formatIndianNumber(totalTaxable)}"),
                              _buildSummaryLine("CGST @ ${(totalTaxRate / 2).toStringAsFixed(1)}%", "₹ ${formatIndianNumber(cgstAmount)}"),
                              _buildSummaryLine("SGST @ ${(totalTaxRate / 2).toStringAsFixed(1)}%", "₹ ${formatIndianNumber(sgstAmount)}"),
                              pw.Divider(color: const PdfColor.fromInt(0xfff2e3c6)),
                              _buildSummaryLine("Total Amount", "₹ ${formatIndianNumber(grandTotal)}", isBold: true),
                            ],
                          ),
                        ),
                        pw.SizedBox(height: 15),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text("For ${companyName.toUpperCase()}", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 35),
                            pw.Text("Authorised Signatory", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );

  return pdf.save();
}

pw.Widget _buildSummaryLine(String label, String value, {bool isBold = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 8, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        pw.Text(value, style: pw.TextStyle(fontSize: 8, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal)),
      ],
    ),
  );
}
