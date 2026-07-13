'use client';

import React, { useState } from 'react';
import InvoiceForm from '../components/InvoiceForm';
import InvoicePreview from '../components/InvoicePreview';
import './invoice.css';

export default function Home() {
  const [viewMode, setViewMode] = useState('form'); // 'form' or 'preview'
  const [invoiceData, setInvoiceData] = useState({
    companyName: 'VEL MURUGAN TRADERS',
    panNo: 'CLUPA7204D',
    gstin: '33CLUPA7204D1ZF',
    phone: '9943353367',
    address: 'DO NO 83/5, 2ND STREET W-8, Thevaram, Theni, Tamil Nadu, 625530',
    invoiceNo: '1',
    invoiceDate: '2026-06-28',
    dueDate: '2026-07-05',
    motorVehicleNo: '28.06.26',
    billTo: 'Kp Green Cardamom',
    shipTo: 'Kp Green Cardamom',
    placeOfSupply: 'Tamil Nadu',
    items: [
      { description: 'cardamom', hsn: '09083120', qty: '100 KGS', rate: 2000, taxRate: 5 }
    ],
    receivedAmount: 0,
    jurisdiction: 'THENI',
    terms: '1. Goods once sold will not be taken back or exchanged\n2. All disputes are subject to [ENTER_YOUR_CITY_NAME] jurisdiction only',
    bankName: 'VELMURUGAN TRADERS',
    bankAccNo: '072539943353367',
    bankBranch: 'PANNAIPURAM',
    bankIfsc: 'TMBL0000072'
  });

  const handleFieldChange = (name, value) => {
    setInvoiceData((prev) => ({
      ...prev,
      [name]: value
    }));
  };

  const handleAddItem = () => {
    setInvoiceData((prev) => ({
      ...prev,
      items: [
        ...prev.items,
        { description: '', hsn: '', qty: '', rate: '', taxRate: 5 }
      ]
    }));
  };

  const handleRemoveItem = (index) => {
    setInvoiceData((prev) => {
      const updatedItems = [...prev.items];
      updatedItems.splice(index, 1);
      return {
        ...prev,
        items: updatedItems
      };
    });
  };

  const handleItemChange = (index, field, value) => {
    setInvoiceData((prev) => {
      const updatedItems = [...prev.items];
      updatedItems[index] = {
        ...updatedItems[index],
        [field]: value
      };
      return {
        ...prev,
        items: updatedItems
      };
    });
  };

  const handleSubmit = () => {
    setViewMode('preview');
  };

  return (
    <main className="app-container">
      {/* Header controls (Hidden during print) */}
      <header className="app-header">
        <div className="logo-section">
          <h1>GST INVOICE ENGINE</h1>
          <p>Create & Download professional Indian GST compliance Tax Invoices</p>
        </div>
        <div className="view-switch">
          <button
            type="button"
            className={`view-btn ${viewMode === 'form' ? 'active' : ''}`}
            onClick={() => setViewMode('form')}
          >
            Invoice Form
          </button>
          <button
            type="button"
            className={`view-btn ${viewMode === 'preview' ? 'active' : ''}`}
            onClick={() => setViewMode('preview')}
          >
            Live Preview
          </button>
        </div>
      </header>

      {/* Main view router */}
      {viewMode === 'form' ? (
        <InvoiceForm
          invoiceData={invoiceData}
          onChange={handleFieldChange}
          onAddItem={handleAddItem}
          onRemoveItem={handleRemoveItem}
          onItemChange={handleItemChange}
          onSubmit={handleSubmit}
        />
      ) : (
        <InvoicePreview
          invoiceData={invoiceData}
          onEdit={() => setViewMode('form')}
        />
      )}
    </main>
  );
}
