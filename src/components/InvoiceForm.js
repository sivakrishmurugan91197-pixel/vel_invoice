'use client';

import React from 'react';

export default function InvoiceForm({
  invoiceData,
  onChange,
  onAddItem,
  onRemoveItem,
  onItemChange,
  onSubmit
}) {
  const handleInputChange = (e) => {
    const { name, value } = e.target;
    onChange(name, value);
  };

  return (
    <form className="form-card" onSubmit={(e) => { e.preventDefault(); onSubmit(); }}>
      <div className="form-grid">
        
        {/* Section: Company Profile */}
        <div className="section-title">
          <span>Company Profile (Invoice Header)</span>
        </div>
        
        <div className="input-group col-6">
          <label className="input-label" htmlFor="companyName">Company Name</label>
          <input
            id="companyName"
            type="text"
            className="input-control"
            name="companyName"
            value={invoiceData.companyName || ''}
            onChange={handleInputChange}
            placeholder="e.g. VEL MURUGAN TRADERS"
            required
          />
        </div>

        <div className="input-group col-3">
          <label className="input-label" htmlFor="panNo">PAN Number</label>
          <input
            id="panNo"
            type="text"
            className="input-control"
            name="panNo"
            value={invoiceData.panNo || ''}
            onChange={handleInputChange}
            placeholder="e.g. CLUPA7204D"
            required
          />
        </div>

        <div className="input-group col-3">
          <label className="input-label" htmlFor="gstin">GSTIN</label>
          <input
            id="gstin"
            type="text"
            className="input-control"
            name="gstin"
            value={invoiceData.gstin || ''}
            onChange={handleInputChange}
            placeholder="e.g. 33CLUPA7204D1ZF"
            required
          />
        </div>

        <div className="input-group col-4">
          <label className="input-label" htmlFor="phone">Phone / Mobile</label>
          <input
            id="phone"
            type="text"
            className="input-control"
            name="phone"
            value={invoiceData.phone || ''}
            onChange={handleInputChange}
            placeholder="e.g. 9943353367"
            required
          />
        </div>

        <div className="input-group col-8">
          <label className="input-label" htmlFor="address">Address</label>
          <input
            id="address"
            type="text"
            className="input-control"
            name="address"
            value={invoiceData.address || ''}
            onChange={handleInputChange}
            placeholder="Company physical address"
            required
          />
        </div>

        {/* Section: Invoice Details */}
        <div className="section-title">
          <span>Invoice Details</span>
        </div>

        <div className="input-group col-3">
          <label className="input-label" htmlFor="invoiceNo">Invoice Number</label>
          <input
            id="invoiceNo"
            type="text"
            className="input-control"
            name="invoiceNo"
            value={invoiceData.invoiceNo || ''}
            onChange={handleInputChange}
            placeholder="e.g. 1"
            required
          />
        </div>

        <div className="input-group col-3">
          <label className="input-label" htmlFor="invoiceDate">Invoice Date</label>
          <input
            id="invoiceDate"
            type="date"
            className="input-control"
            name="invoiceDate"
            value={invoiceData.invoiceDate || ''}
            onChange={handleInputChange}
            required
          />
        </div>

        <div className="input-group col-3">
          <label className="input-label" htmlFor="dueDate">Due Date</label>
          <input
            id="dueDate"
            type="date"
            className="input-control"
            name="dueDate"
            value={invoiceData.dueDate || ''}
            onChange={handleInputChange}
            required
          />
        </div>

        <div className="input-group col-3">
          <label className="input-label" htmlFor="motorVehicleNo">Motor Vehicle No</label>
          <input
            id="motorVehicleNo"
            type="text"
            className="input-control"
            name="motorVehicleNo"
            value={invoiceData.motorVehicleNo || ''}
            onChange={handleInputChange}
            placeholder="e.g. 28.06.26"
          />
        </div>

        {/* Section: Billing & Shipping */}
        <div className="section-title">
          <span>Billing & Shipping</span>
        </div>

        <div className="input-group col-6">
          <label className="input-label" htmlFor="billTo">Bill To (Name & Address)</label>
          <textarea
            id="billTo"
            className="input-control"
            name="billTo"
            value={invoiceData.billTo || ''}
            onChange={handleInputChange}
            placeholder="Client Name & Address details"
            rows="3"
            required
          />
        </div>

        <div className="input-group col-6">
          <label className="input-label" htmlFor="shipTo">Ship To (Name & Address)</label>
          <textarea
            id="shipTo"
            className="input-control"
            name="shipTo"
            value={invoiceData.shipTo || ''}
            onChange={handleInputChange}
            placeholder="Delivery Name & Address details"
            rows="3"
            required
          />
        </div>

        <div className="input-group col-6">
          <label className="input-label" htmlFor="placeOfSupply">Place of Supply</label>
          <input
            id="placeOfSupply"
            type="text"
            className="input-control"
            name="placeOfSupply"
            value={invoiceData.placeOfSupply || ''}
            onChange={handleInputChange}
            placeholder="e.g. Tamil Nadu"
            required
          />
        </div>

        {/* Section: Items Table */}
        <div className="section-title">
          <span>Invoice Items</span>
        </div>

        <div className="items-table-container">
          <table className="items-table">
            <thead>
              <tr>
                <th style={{ width: '6%' }}>No</th>
                <th style={{ width: '38%' }}>Item Description</th>
                <th style={{ width: '15%' }}>HSN Code</th>
                <th style={{ width: '10%' }}>Qty</th>
                <th style={{ width: '10%' }}>Rate</th>
                <th style={{ width: '12%' }}>Tax Rate (%)</th>
                <th style={{ width: '8%' }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {invoiceData.items.map((item, index) => (
                <tr key={index}>
                  <td>
                    <input
                      type="number"
                      className="input-control"
                      value={index + 1}
                      disabled
                      style={{ textAlign: 'center', background: 'transparent', border: 'none' }}
                    />
                  </td>
                  <td>
                    <input
                      type="text"
                      className="input-control"
                      value={item.description}
                      onChange={(e) => onItemChange(index, 'description', e.target.value)}
                      placeholder="e.g. Cardamom"
                      required
                    />
                  </td>
                  <td>
                    <input
                      type="text"
                      className="input-control"
                      value={item.hsn}
                      onChange={(e) => onItemChange(index, 'hsn', e.target.value)}
                      placeholder="e.g. 09083120"
                      required
                    />
                  </td>
                  <td>
                    <input
                      type="text"
                      className="input-control"
                      value={item.qty}
                      onChange={(e) => onItemChange(index, 'qty', e.target.value)}
                      placeholder="e.g. 100 KGS"
                      required
                    />
                  </td>
                  <td>
                    <input
                      type="number"
                      step="any"
                      className="input-control"
                      value={item.rate}
                      onChange={(e) => onItemChange(index, 'rate', e.target.value)}
                      placeholder="e.g. 2000"
                      required
                    />
                  </td>
                  <td>
                    <select
                      className="input-control"
                      value={item.taxRate}
                      onChange={(e) => onItemChange(index, 'taxRate', Number(e.target.value))}
                    >
                      <option value={0}>0%</option>
                      <option value={5}>5%</option>
                      <option value={12}>12%</option>
                      <option value={18}>18%</option>
                      <option value={28}>28%</option>
                    </select>
                  </td>
                  <td style={{ textAlign: 'center' }}>
                    <button
                      type="button"
                      className="remove-btn"
                      onClick={() => onRemoveItem(index)}
                      disabled={invoiceData.items.length <= 1}
                      title="Remove Row"
                    >
                      ✕
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>

          <button type="button" className="add-row-btn" onClick={onAddItem}>
            + Add New Item Row
          </button>
        </div>

        {/* Section: Bank Details */}
        <div className="section-title">
          <span>Bank Details</span>
        </div>

        <div className="input-group col-6">
          <label className="input-label" htmlFor="bankName">A/c Name</label>
          <input
            id="bankName"
            type="text"
            className="input-control"
            name="bankName"
            value={invoiceData.bankName || ''}
            onChange={handleInputChange}
            placeholder="e.g. VELMURUGAN TRADERS"
          />
        </div>

        <div className="input-group col-6">
          <label className="input-label" htmlFor="bankAccNo">A/c Number</label>
          <input
            id="bankAccNo"
            type="text"
            className="input-control"
            name="bankAccNo"
            value={invoiceData.bankAccNo || ''}
            onChange={handleInputChange}
            placeholder="e.g. 072539943353367"
          />
        </div>

        <div className="input-group col-6">
          <label className="input-label" htmlFor="bankBranch">Branch</label>
          <input
            id="bankBranch"
            type="text"
            className="input-control"
            name="bankBranch"
            value={invoiceData.bankBranch || ''}
            onChange={handleInputChange}
            placeholder="e.g. PANNAIPURAM"
          />
        </div>

        <div className="input-group col-6">
          <label className="input-label" htmlFor="bankIfsc">IFSC Code</label>
          <input
            id="bankIfsc"
            type="text"
            className="input-control"
            name="bankIfsc"
            value={invoiceData.bankIfsc || ''}
            onChange={handleInputChange}
            placeholder="e.g. TMBL0000072"
          />
        </div>

        {/* Section: Additional Details */}
        <div className="section-title">
          <span>Terms & Conditions & Totals</span>
        </div>

        <div className="input-group col-7">
          <label className="input-label" htmlFor="terms">Terms & Conditions</label>
          <textarea
            id="terms"
            className="input-control"
            name="terms"
            value={invoiceData.terms || ''}
            onChange={handleInputChange}
            rows="4"
            placeholder="Terms and conditions..."
          />
        </div>

        <div className="input-group col-5">
          <label className="input-label" htmlFor="receivedAmount">Received Amount (₹)</label>
          <input
            id="receivedAmount"
            type="number"
            className="input-control"
            name="receivedAmount"
            value={invoiceData.receivedAmount === undefined ? '' : invoiceData.receivedAmount}
            onChange={handleInputChange}
            placeholder="e.g. 0"
          />
          
          <label className="input-label" htmlFor="jurisdiction" style={{ marginTop: '0.8rem' }}>City Jurisdiction</label>
          <input
            id="jurisdiction"
            type="text"
            className="input-control"
            name="jurisdiction"
            value={invoiceData.jurisdiction || ''}
            onChange={handleInputChange}
            placeholder="e.g. THENI"
          />
        </div>

        {/* Actions bar at bottom */}
        <div className="form-actions">
          <button type="submit" className="btn btn-primary">
            Preview & Generate PDF ➔
          </button>
        </div>

      </div>
    </form>
  );
}
