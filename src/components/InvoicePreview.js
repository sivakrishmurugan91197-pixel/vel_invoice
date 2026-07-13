'use client';

import React from 'react';
import { convertNumberToWords } from '../utils/numberToWords';

export default function InvoicePreview({ invoiceData, onEdit }) {
  // Helper to format currency in Indian style
  const formatIndianNumber = (num) => {
    if (num === null || num === undefined || isNaN(num)) return "0";
    const numVal = Number(num);
    const hasDecimal = numVal % 1 !== 0;
    const parts = numVal.toFixed(hasDecimal ? 2 : 0).split(".");
    let lastThree = parts[0].substring(parts[0].length - 3);
    const otherRooms = parts[0].substring(0, parts[0].length - 3);
    if (otherRooms !== "") {
      lastThree = "," + lastThree;
    }
    const mainPart = otherRooms.replace(/\B(?=(\d{2})+(?!\d))/g, ",") + lastThree;
    return hasDecimal ? mainPart + "." + parts[1] : mainPart;
  };

  // Calculations
  const calculatedItems = invoiceData.items.map((item) => {
    const qtyNum = parseFloat(item.qty) || 0;
    const rateNum = parseFloat(item.rate) || 0;
    const taxable = qtyNum * rateNum;
    const tax = taxable * (item.taxRate / 100);
    const total = taxable + tax;
    return {
      ...item,
      qtyNum,
      rateNum,
      taxable,
      tax,
      total
    };
  });

  const subtotalQty = calculatedItems.reduce((sum, item) => sum + item.qtyNum, 0);
  const subtotalTax = calculatedItems.reduce((sum, item) => sum + item.tax, 0);
  const subtotalTotal = calculatedItems.reduce((sum, item) => sum + item.total, 0);

  const taxableAmount = calculatedItems.reduce((sum, item) => sum + item.taxable, 0);
  
  // Split taxes (CGST and SGST are 50% each of the total tax rate, e.g. 5% tax is CGST 2.5% + SGST 2.5%)
  const cgstAmount = subtotalTax / 2;
  const sgstAmount = subtotalTax / 2;
  const grandTotal = taxableAmount + subtotalTax;
  const receivedAmount = parseFloat(invoiceData.receivedAmount) || 0;
  
  const wordsAmount = convertNumberToWords(grandTotal);

  // Pad the items list with empty rows to match the image layout
  const minRows = 8;
  const paddingRowsCount = Math.max(0, minRows - calculatedItems.length);
  const paddingRows = Array.from({ length: paddingRowsCount });

  // Format dates for invoice display (YYYY-MM-DD -> DD/MM/YYYY)
  const formatDate = (dateStr) => {
    if (!dateStr) return '';
    const parts = dateStr.split('-');
    if (parts.length === 3) {
      return `${parts[2]}/${parts[1]}/${parts[0]}`;
    }
    return dateStr;
  };

  const handleDownloadPDF = () => {
    const element = document.getElementById('invoice-sheet');
    const opt = {
      margin: 0,
      filename: `Tax_Invoice_${invoiceData.invoiceNo || '1'}.pdf`,
      image: { type: 'jpeg', quality: 0.98 },
      html2canvas: { scale: 2.5, useCORS: true, logging: false, scrollX: 0, scrollY: 0 },
      jsPDF: { unit: 'in', format: 'a4', orientation: 'portrait' }
    };

    const runPdfWorker = () => {
      window.html2pdf().from(element).set(opt).toPdf().get('pdf').then((pdf) => {
        // 1. Save the file using the jsPDF save method directly
        pdf.save(opt.filename);
        
        // 2. Fallback: Open compiled PDF blob in a new tab so they can save/print it cleanly if download is renamed/blocked
        const blob = pdf.output('blob');
        const blobUrl = URL.createObjectURL(blob);
        const newWindow = window.open(blobUrl, '_blank');
        if (!newWindow) {
          alert('Popup blocked! Please allow popups to view the PDF preview.');
        }
      });
    };
    
    if (window.html2pdf) {
      // If script is already loaded globally, run PDF generation immediately
      runPdfWorker();
    } else {
      // Inject html2pdf script dynamically only once
      const script = document.createElement('script');
      script.src = 'https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js';
      script.onload = runPdfWorker;
      document.body.appendChild(script);
    }
  };

  const handleShareWhatsApp = () => {
    // Format the phone number dynamically from the form (prepending 91 if it's a 10-digit number)
    const rawPhone = invoiceData.phone || '';
    const cleanPhone = rawPhone.replace(/\D/g, ''); // keep only digits
    const targetPhone = cleanPhone.length === 10 ? `91${cleanPhone}` : cleanPhone;

    const message = `Tax Invoice: ${invoiceData.invoiceNo || '1'}\nDate: ${invoiceData.invoiceDate}\nCompany: ${invoiceData.companyName || 'VEL MURUGAN TRADERS'}\nTotal: ₹ ${formatIndianNumber(grandTotal)}`;
    const url = `https://api.whatsapp.com/send?phone=${targetPhone}&text=${encodeURIComponent(message)}`;
    window.open(url, '_blank');
  };

  const handlePrint = () => {
    window.print();
  };

  // Replace city name placeholder in Terms and Conditions
  const renderedTerms = invoiceData.terms
    ? invoiceData.terms.replace(/\[ENTER_YOUR_CITY_NAME\]/gi, invoiceData.jurisdiction || 'THENI')
    : '';

  return (
    <div className="invoice-preview-container">
      {/* Control Buttons */}
      <div className="preview-actions-bar">
        <button className="btn btn-secondary" onClick={onEdit}>
          ⬅ Edit Invoice Form
        </button>
        <div className="action-buttons-group">
          <button className="btn btn-whatsapp" onClick={handleShareWhatsApp}>
            Share to WhatsApp
          </button>
          <button className="btn btn-secondary" onClick={handlePrint}>
            Print Invoice
          </button>
          <button className="btn btn-primary" onClick={handleDownloadPDF}>
            Download PDF
          </button>
        </div>
      </div>

      {/* Printable Sheet */}
      <div id="invoice-sheet" className="invoice-paper">
        <div className="invoice-frame">
          
          <div>
            {/* Header Row */}
            <div className="invoice-header-row">
              <div className="header-left">
                <div className="company-title">{invoiceData.companyName || 'VEL MURUGAN TRADERS'}</div>
                <div className="company-tax-info">
                  Pan No <span>{invoiceData.panNo || 'CLUPA7204D'}</span> &nbsp;&nbsp;&nbsp;&nbsp;
                  GSTIN <span>{invoiceData.gstin || '33CLUPA7204D1ZF'}</span>
                </div>
                <div className="company-contact">
                  <div className="contact-item">
                    <span className="contact-icon">📞</span>
                    <span>{invoiceData.phone || '9943353367'}</span>
                  </div>
                  <div className="contact-item">
                    <span className="contact-icon">📍</span>
                    <span>{invoiceData.address || 'DO NO 83/5, 2ND STREET W-8, Thevaram, Theni, Tamil Nadu, 625530'}</span>
                  </div>
                </div>
              </div>
              <div className="header-right">
                <img src="/logo.png" alt="Vel Murugan Traders Logo" className="invoice-logo" />
              </div>
            </div>

            {/* Invoice Meta Row */}
            <div className="invoice-meta-row">
              <div className="meta-column">
                <div className="meta-label">Invoice No.</div>
                <div className="meta-value">{invoiceData.invoiceNo || '1'}</div>
              </div>
              <div className="meta-column">
                <div className="meta-label">Invoice Date</div>
                <div className="meta-value">{formatDate(invoiceData.invoiceDate)}</div>
              </div>
              <div className="meta-column vehicle-column">
                <div className="meta-label vehicle-label">motor vehicle no:</div>
                <div className="meta-value vehicle-value">{invoiceData.motorVehicleNo || '28.06.26'}</div>
              </div>
            </div>

            {/* Billing & Shipping Row */}
            <div className="billing-shipping-row">
              <div className="bill-to-section">
                <div className="bill-ship-label">Bill To</div>
                <div className="address-block" style={{ whiteSpace: 'pre-line' }}>
                  {invoiceData.billTo || 'Kp Green Cardamom'}
                </div>
                <div className="place-of-supply">
                  Place of Supply <span>{invoiceData.placeOfSupply || 'Tamil Nadu'}</span>
                </div>
              </div>
              <div className="ship-to-section">
                <div className="bill-ship-label">Ship To</div>
                <div className="address-block" style={{ whiteSpace: 'pre-line' }}>
                  {invoiceData.shipTo || 'Kp Green Cardamom'}
                </div>
              </div>
            </div>
          </div>

          {/* Table Area */}
          <table className="invoice-items-table">
            <thead>
              <tr>
                <th style={{ width: '6%', textAlign: 'center' }}>No</th>
                <th style={{ width: '42%' }}>Items</th>
                <th style={{ width: '15%' }}>HSN No.</th>
                <th style={{ width: '10%', textAlign: 'right' }}>Qty.</th>
                <th style={{ width: '10%', textAlign: 'right' }}>Rate</th>
                <th style={{ width: '12%', textAlign: 'right' }}>Tax</th>
                <th style={{ width: '15%', textAlign: 'right' }}>Total</th>
              </tr>
            </thead>
            <tbody>
              {calculatedItems.map((item, idx) => (
                <tr key={idx}>
                  <td className="align-center">{idx + 1}</td>
                  <td>{item.description}</td>
                  <td>{item.hsn}</td>
                  <td className="align-right">{item.qty}</td>
                  <td className="align-right">{formatIndianNumber(item.rateNum)}</td>
                  <td className="align-right">
                    {formatIndianNumber(item.tax)}
                    <div className="tax-rate-subtext">
                      ({item.taxRate}%)
                    </div>
                  </td>
                  <td className="align-right">{formatIndianNumber(item.total)}</td>
                </tr>
              ))}
              
              {/* Padding Rows to keep layout exact and beautiful */}
              {paddingRows.map((_, idx) => (
                <tr key={`pad-${idx}`} className="table-fill-row">
                  <td className="align-center">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              ))}

              {/* Subtotal Row */}
              <tr className="subtotal-row">
                <td colSpan="3" style={{ textAlign: 'left', paddingLeft: '15px' }}>SUBTOTAL</td>
                <td className="align-right">{subtotalQty || ''}</td>
                <td className="align-right">&nbsp;</td>
                <td className="align-right">₹ {formatIndianNumber(subtotalTax)}</td>
                <td className="align-right">₹ {formatIndianNumber(subtotalTotal)}</td>
              </tr>
            </tbody>
          </table>

          {/* Footer Area */}
          <div className="invoice-footer-section">
            <div className="footer-left">
              <div className="words-amount-section">
                <div className="words-label">Total Amount (in words)</div>
                <div className="words-value">{wordsAmount.replace(/ Only$/i, "")}</div>
              </div>
              
              <div className="bank-details-section">
                <div className="bank-title">Bank Details:</div>
                <div className="bank-detail-line">A/c Name : <span className="bank-value">{invoiceData.bankName || 'VELMURUGAN TRADERS'}</span></div>
                <div className="bank-detail-line">A/c No : <span className="bank-value">{invoiceData.bankAccNo || '072539943353367'}</span></div>
                <div className="bank-detail-line">Branch: <span className="bank-value">{invoiceData.bankBranch || 'PANNAIPURAM'}</span></div>
                <div className="bank-detail-line">IFSC Code :<span className="bank-value">{invoiceData.bankIfsc || 'TMBL0000072'}</span></div>
              </div>
            </div>
            
            <div className="footer-right">
              <div className="summary-block">
                <div className="summary-line">
                  <span>Taxable Amount</span>
                  <span>₹ {formatIndianNumber(taxableAmount)}</span>
                </div>
                <div className="summary-line">
                  <span>CGST @ {(invoiceData.items[0]?.taxRate || 5) / 2}%</span>
                  <span>₹ {formatIndianNumber(cgstAmount)}</span>
                </div>
                <div className="summary-line">
                  <span>SGST @ {(invoiceData.items[0]?.taxRate || 5) / 2}%</span>
                  <span>₹ {formatIndianNumber(sgstAmount)}</span>
                </div>
                <div className="summary-line bold-line">
                  <span>Total Amount</span>
                  <span>₹ {formatIndianNumber(grandTotal)}</span>
                </div>
              </div>
              
              <div className="signature-section">
                <div className="signature-for">For. {invoiceData.companyName || 'Vel Murugan Traders'}</div>
                <div className="signature-space"></div>
                <div className="signature-title">Authorised Signatory</div>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>
  );
}
