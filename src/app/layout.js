import "./globals.css";

export const metadata = {
  title: "Tax Invoice Generator | VEL MURUGAN TRADERS",
  description: "Generate, preview, edit, and download GST compliant tax invoices with custom details and print layouts.",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
