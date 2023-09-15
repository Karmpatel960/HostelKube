const mongoose = require("mongoose");

const paymentConfirmationSchema = new mongoose.Schema({
  studentId: String,
  paymentDate: Date,
  razorpayPaymentId: String, 
});

const PaymentConfirmation = mongoose.model("PaymentConfirmation", paymentConfirmationSchema);

module.exports = PaymentConfirmation;
