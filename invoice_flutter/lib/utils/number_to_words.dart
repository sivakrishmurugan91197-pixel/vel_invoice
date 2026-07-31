String convertNumberToWords(double? num) {
  if (num == null || num.isNaN) return "";

  final List<String> ones = [
    "", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten",
    "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"
  ];

  final List<String> tens = [
    "", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"
  ];

  String convertLessThanThousand(int n) {
    if (n == 0) return "";
    String str = "";
    if (n >= 100) {
      str += "${ones[n ~/ 100]} Hundred ";
      n %= 100;
    }
    if (n >= 20) {
      str += "${tens[n ~/ 10]} ";
      n %= 10;
    }
    if (n > 0) {
      str += "${ones[n]} ";
    }
    return str.trim();
  }

  // Split integer and decimal parts
  String fixedStr = num.toStringAsFixed(2);
  List<String> parts = fixedStr.split(".");
  int integerPart = int.parse(parts[0]);
  int decimalPart = int.parse(parts[1]);

  if (integerPart == 0 && decimalPart == 0) {
    return "Zero Rupees Only";
  }

  String words = "";

  if (integerPart > 0) {
    int remaining = integerPart;

    // Crores (1,00,00,000)
    if (remaining >= 10000000) {
      int crores = remaining ~/ 10000000;
      words += "${convertLessThanThousand(crores)} Crore ";
      remaining %= 10000000;
    }

    // Lakhs (1,00,000)
    if (remaining >= 100000) {
      int lakhs = remaining ~/ 100000;
      words += "${convertLessThanThousand(lakhs)} Lakh ";
      remaining %= 100000;
    }

    // Thousands (1,000)
    if (remaining >= 1000) {
      int thousands = remaining ~/ 1000;
      words += "${convertLessThanThousand(thousands)} Thousand ";
      remaining %= 1000;
    }

    // Remaining Hundreds/Tens/Ones
    if (remaining > 0) {
      words += "${convertLessThanThousand(remaining)} ";
    }

    words = "${words.trim()} Rupees";
  }

  if (decimalPart > 0) {
    String paiseWords = convertLessThanThousand(decimalPart);
    if (words.isNotEmpty) {
      words += " and $paiseWords Paise";
    } else {
      words = "$paiseWords Paise";
    }
  }

  return words.isNotEmpty ? "${words.trim()} Only" : "";
}
