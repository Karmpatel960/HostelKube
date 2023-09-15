const mongoose = require("mongoose");

const feeSchema = new mongoose.Schema({
  studentId: String,
  paymentDate: Date,
  roomCharges: Number,        
  messFoodCharges: Number,    
  totalAmount: Number,       
  paymentMethod: String,
  receiptGenerated: Boolean,
  razorpayPaymentId: String,   
});

const Fee = mongoose.model("Fee", feeSchema);

module.exports = Fee;

