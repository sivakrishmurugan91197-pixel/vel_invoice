/**
 * Converts a numeric amount to Indian Currency Words (Rupees and Paise)
 * Example: 210000 -> "Two Lakh Ten Thousand Rupees Only"
 */
export function convertNumberToWords(num) {
  if (num === null || num === undefined || isNaN(num)) return "";

  const ones = [
    "", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten",
    "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"
  ];

  const tens = [
    "", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"
  ];

  function convertLessThanThousand(n) {
    if (n === 0) return "";
    let str = "";
    if (n >= 100) {
      str += ones[Math.floor(n / 100)] + " Hundred ";
      n %= 100;
    }
    if (n >= 20) {
      str += tens[Math.floor(n / 10)] + " ";
      n %= 10;
    }
    if (n > 0) {
      str += ones[n] + " ";
    }
    return str.trim();
  }

  // Split integer and decimal parts
  const parts = Number(num).toFixed(2).split(".");
  const integerPart = parseInt(parts[0], 10);
  const decimalPart = parseInt(parts[1], 10);

  if (integerPart === 0 && decimalPart === 0) {
    return "Zero Rupees Only";
  }

  let words = "";

  if (integerPart > 0) {
    let remaining = integerPart;

    // Crores (1,00,00,000)
    if (remaining >= 10000000) {
      const crores = Math.floor(remaining / 10000000);
      words += convertLessThanThousand(crores) + " Crore ";
      remaining %= 10000000;
    }

    // Lakhs (1,00,000)
    if (remaining >= 100000) {
      const lakhs = Math.floor(remaining / 100000);
      words += convertLessThanThousand(lakhs) + " Lakh ";
      remaining %= 100000;
    }

    // Thousands (1,000)
    if (remaining >= 1000) {
      const thousands = Math.floor(remaining / 1000);
      words += convertLessThanThousand(thousands) + " Thousand ";
      remaining %= 1000;
    }

    // Remaining Hundreds/Tens/Ones
    if (remaining > 0) {
      words += convertLessThanThousand(remaining) + " ";
    }

    words = words.trim() + " Rupees";
  }

  if (decimalPart > 0) {
    const paiseWords = convertLessThanThousand(decimalPart);
    if (words) {
      words += " and " + paiseWords + " Paise";
    } else {
      words = paiseWords + " Paise";
    }
  }

  return words ? words.trim() + " Only" : "";
}
