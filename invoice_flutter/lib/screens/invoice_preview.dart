import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../utils/invoice_pdf_helper.dart';

class InvoicePreviewScreen extends StatelessWidget {
  final Map<String, dynamic> invoiceData;

  const InvoicePreviewScreen({super.key, required this.invoiceData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'INVOICE PREVIEW',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        backgroundColor: const Color(0xff162642),
        foregroundColor: Colors.white,
      ),
      body: PdfPreview(
        build: (format) => generateInvoicePdf(invoiceData),
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        pdfFileName: 'Tax_Invoice_${invoiceData['invoiceNo'] ?? '1'}.pdf',
        // Styling options for PdfPreview matching the app aesthetic
        actions: const [],
        loadingWidget: const Center(
          child: CircularProgressIndicator(
            color: Color(0xff162642),
          ),
        ),
      ),
    );
  }
}
