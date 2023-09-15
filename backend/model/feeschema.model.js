const mongoose = require("mongoose");

const feeSchema = new mongoose.Schema({
  studentId: String,
  paymentDate: Date,
  amount: Number,
  paymentMethod: String,
  receiptGenerated: Boolean,
});

const Fee = mongoose.model("Fee", feeSchema);

module.exports = Fee;


const mongoose = require("mongoose");

const paymentConfirmationSchema = new mongoose.Schema({
  studentId: String,
  paymentDate: Date,
  // Other payment confirmation details
});

const PaymentConfirmation = mongoose.model("PaymentConfirmation", paymentConfirmationSchema);

module.exports = PaymentConfirmation;

