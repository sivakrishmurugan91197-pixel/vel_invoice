import 'package:flutter/material';
import 'invoice_preview.dart';

class InvoiceFormScreen extends StatefulWidget {
  const InvoiceFormScreen({super.key});

  @override
  State<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends State<InvoiceFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // State maps
  final Map<String, dynamic> _invoiceData = {
    'companyName': 'VEL MURUGAN TRADERS',
    'panNo': 'CLUPA7204D',
    'gstin': '33CLUPA7204D1ZF',
    'phone': '9943353367',
    'address': 'DO NO 83/5, 2ND STREET W-8, Thevaram, Theni, Tamil Nadu, 625530',
    'invoiceNo': '1',
    'invoiceDate': '2026-06-28',
    'dueDate': '2026-07-05',
    'motorVehicleNo': '28.06.26',
    'billTo': 'Kp Green Cardamom',
    'shipTo': 'Kp Green Cardamom',
    'placeOfSupply': 'Tamil Nadu',
    'items': [
      {'description': 'cardamom', 'hsn': '09083120', 'qty': '100 KGS', 'rate': '2000', 'taxRate': 5.0}
    ],
    'receivedAmount': '0',
    'jurisdiction': 'THENI',
    'terms': '1. Goods once sold will not be taken back or exchanged\n2. All disputes are subject to [ENTER_YOUR_CITY_NAME] jurisdiction only',
    'bankName': 'VELMURUGAN TRADERS',
    'bankAccNo': '072539943353367',
    'bankBranch': 'PANNAIPURAM',
    'bankIfsc': 'TMBL0000072'
  };

  void _addItem() {
    setState(() {
      final items = List<Map<String, dynamic>>.from(_invoiceData['items']);
      items.add({
        'description': '',
        'hsn': '',
        'qty': '',
        'rate': '',
        'taxRate': 5.0,
      });
      _invoiceData['items'] = items;
    });
  }

  void _removeItem(int index) {
    setState(() {
      final items = List<Map<String, dynamic>>.from(_invoiceData['items']);
      if (items.length > 1) {
        items.removeAt(index);
        _invoiceData['items'] = items;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GST INVOICE ENGINE',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff162642),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header description card
                Card(
                  color: const Color(0xff162642).withOpacity(0.05),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xfff2e3c6)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create GST Compliance Invoice',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff162642),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Fill out the form below to generate a beautiful, print-ready PDF invoice.',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Section 1: Company Profile
                _buildSectionHeader('Company Profile (Header)'),
                _buildCard([
                  _buildTextField(
                    label: 'Company Name',
                    initialValue: _invoiceData['companyName'],
                    onChanged: (val) => _invoiceData['companyName'] = val,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'PAN Number',
                          initialValue: _invoiceData['panNo'],
                          onChanged: (val) => _invoiceData['panNo'] = val,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          label: 'GSTIN',
                          initialValue: _invoiceData['gstin'],
                          onChanged: (val) => _invoiceData['gstin'] = val,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildTextField(
                          label: 'Phone / Mobile',
                          initialValue: _invoiceData['phone'],
                          keyboardType: TextInputType.phone,
                          onChanged: (val) => _invoiceData['phone'] = val,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: _buildTextField(
                          label: 'Address',
                          initialValue: _invoiceData['address'],
                          onChanged: (val) => _invoiceData['address'] = val,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                ]),
                const SizedBox(height: 16),

                // Section 2: Invoice Details
                _buildSectionHeader('Invoice Details'),
                _buildCard([
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Invoice Number',
                          initialValue: _invoiceData['invoiceNo'],
                          onChanged: (val) => _invoiceData['invoiceNo'] = val,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          label: 'Motor Vehicle No.',
                          initialValue: _invoiceData['motorVehicleNo'],
                          onChanged: (val) => _invoiceData['motorVehicleNo'] = val,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Invoice Date (YYYY-MM-DD)',
                          initialValue: _invoiceData['invoiceDate'],
                          onChanged: (val) => _invoiceData['invoiceDate'] = val,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          label: 'Due Date (YYYY-MM-DD)',
                          initialValue: _invoiceData['dueDate'],
                          onChanged: (val) => _invoiceData['dueDate'] = val,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                ]),
                const SizedBox(height: 16),

                // Section 3: Billing & Shipping
                _buildSectionHeader('Billing & Shipping'),
                _buildCard([
                  _buildTextField(
                    label: 'Bill To (Name & Address)',
                    initialValue: _invoiceData['billTo'],
                    maxLines: 3,
                    onChanged: (val) => _invoiceData['billTo'] = val,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  _buildTextField(
                    label: 'Ship To (Name & Address)',
                    initialValue: _invoiceData['shipTo'],
                    maxLines: 3,
                    onChanged: (val) => _invoiceData['shipTo'] = val,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  _buildTextField(
                    label: 'Place of Supply',
                    initialValue: _invoiceData['placeOfSupply'],
                    onChanged: (val) => _invoiceData['placeOfSupply'] = val,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ]),
                const SizedBox(height: 16),

                // Section 4: Items
                _buildSectionHeader('Invoice Items'),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _invoiceData['items'].length,
                  itemBuilder: (context, index) {
                    final item = _invoiceData['items'][index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Item #${index + 1}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if (_invoiceData['items'].length > 1)
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _removeItem(index),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildTextField(
                              label: 'Item Description',
                              initialValue: item['description'],
                              onChanged: (val) => item['description'] = val,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _buildTextField(
                                    label: 'HSN Code',
                                    initialValue: item['hsn'],
                                    onChanged: (val) => item['hsn'] = val,
                                    validator: (v) => v!.isEmpty ? 'Required' : null,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: _buildTextField(
                                    label: 'Qty (e.g. 100 KGS)',
                                    initialValue: item['qty'],
                                    onChanged: (val) => item['qty'] = val,
                                    validator: (v) => v!.isEmpty ? 'Required' : null,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _buildTextField(
                                    label: 'Rate (₹)',
                                    initialValue: item['rate'].toString(),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    onChanged: (val) => item['rate'] = val,
                                    validator: (v) => double.tryParse(v!) == null ? 'Must be number' : null,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: DropdownButtonFormField<double>(
                                    decoration: const InputDecoration(
                                      labelText: 'Tax Rate (%)',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    ),
                                    value: item['taxRate'],
                                    items: const [
                                      DropdownMenuItem(value: 0.0, child: Text('0%')),
                                      DropdownMenuItem(value: 5.0, child: Text('5%')),
                                      DropdownMenuItem(value: 12.0, child: Text('12%')),
                                      DropdownMenuItem(value: 18.0, child: Text('18%')),
                                      DropdownMenuItem(value: 28.0, child: Text('28%')),
                                    ],
                                    onChanged: (val) {
                                      setState(() {
                                        item['taxRate'] = val;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                OutlinedButton.icon(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add, color: Color(0xff162642)),
                  label: const Text('Add New Item Row', style: TextStyle(color: Color(0xff162642))),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xff162642)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),

                // Section 5: Bank Details
                _buildSectionHeader('Bank Details'),
                _buildCard([
                  _buildTextField(
                    label: 'Account Name',
                    initialValue: _invoiceData['bankName'],
                    onChanged: (val) => _invoiceData['bankName'] = val,
                  ),
                  _buildTextField(
                    label: 'Account Number',
                    initialValue: _invoiceData['bankAccNo'],
                    onChanged: (val) => _invoiceData['bankAccNo'] = val,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Branch',
                          initialValue: _invoiceData['bankBranch'],
                          onChanged: (val) => _invoiceData['bankBranch'] = val,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          label: 'IFSC Code',
                          initialValue: _invoiceData['bankIfsc'],
                          onChanged: (val) => _invoiceData['bankIfsc'] = val,
                        ),
                      ),
                    ],
                  ),
                ]),
                const SizedBox(height: 16),

                // Section 6: Additional details & Jurisdiction
                _buildSectionHeader('Terms & Conditions & Totals'),
                _buildCard([
                  _buildTextField(
                    label: 'Terms & Conditions',
                    initialValue: _invoiceData['terms'],
                    maxLines: 4,
                    onChanged: (val) => _invoiceData['terms'] = val,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'City Jurisdiction',
                          initialValue: _invoiceData['jurisdiction'],
                          onChanged: (val) => _invoiceData['jurisdiction'] = val,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          label: 'Received Amount (₹)',
                          initialValue: _invoiceData['receivedAmount'].toString(),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (val) => _invoiceData['receivedAmount'] = val,
                        ),
                      ),
                    ],
                  ),
                ]),
                const SizedBox(height: 24),

                // Generate Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvoicePreviewScreen(
                            invoiceData: _invoiceData,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please correct invalid entries in the form.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff162642),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Preview & Generate PDF ➔',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xff162642),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String? initialValue,
    required ValueChanged<String> onChanged,
    FormFieldValidator<String>? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
