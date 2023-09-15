const pdfkit = require("pdfkit");
const fs = require("fs");

// Function to generate a PDF receipt
function generatePDFReceipt(userDetails, paymentDetails) {
  const doc = new pdfkit();
  doc.pipe(fs.createWriteStream("receipt.pdf"));

  // Set up the company logo and name
  doc.image("company-logo.png", 50, 50, { width: 100 });
  doc.fontSize(16).text("Company Name", { align: "center" });

  // Customize the PDF receipt layout here
  doc.fontSize(12).text("Fee Payment Receipt", { align: "center" });
  
  // Add a line below the header
  doc.moveDown(1);
  doc.lineWidth(1).moveTo(50, doc.y).lineTo(550, doc.y).stroke();

  doc.moveDown(1);

  // User Information Section
  doc.fontSize(14).text("User Information:");
  doc.fontSize(12).text(`Name: ${userDetails.name}`);
  doc.text(`Email: ${userDetails.email}`);
  
  // Payment Information Section
  doc.moveDown(1);
  doc.fontSize(14).text("Payment Information:");
  doc.fontSize(12).text(`Payment Date: ${paymentDetails.paymentDate}`);
  doc.text(`Amount: $${paymentDetails.amount}`);
  
  // Table for Fee Payment Details
  const table = {
    headers: ["Description", "Amount"],
    rows: [
      ["Room Charges", "$50"],
      ["Mess Food Charges", "$30"],
    ],
  };

  const tableX = 50; // X-coordinate for the table
  const tableY = doc.y + 30; // Y-coordinate for the table
  const tableWidth = 500; // Width of the table
  const tableHeight = 100; // Height of the table
  const cellPadding = 10; // Padding for table cells

  // Draw the table
  doc.table(tableX, tableY, table, {
    prepareHeader: () => doc.fontSize(12).text("Description", tableX + cellPadding, tableY + cellPadding),
    prepareRow: (row, i) => {
      doc.fontSize(12).text(row.description, tableX + cellPadding, tableY + cellPadding + (i + 1) * 20);
      doc.text(row.amount, tableX + tableWidth - 100, tableY + cellPadding + (i + 1) * 20);
    },
    headerHeight: 30,
    rowHeight: 20,
  });

  const totalAmount = table.rows.reduce((acc, row) => acc + parseFloat(row.amount.slice(1)), 0);
  doc.fontSize(14).text(`Total Amount: $${totalAmount.toFixed(2)}`);

  doc.end();
}

const userDetails = {
  name: "John Doe",
  email: "john@example.com",
};

const paymentDetails = {
  paymentDate: "2023-09-15",
  amount: 80,
};

generatePDFReceipt(userDetails, paymentDetails);
