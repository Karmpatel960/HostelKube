const mongoose = require("mongoose");

const lightBillSchema = new mongoose.Schema({
  roomId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Room",
    required: true,
  },
  billMonth: Date, 
  totalAmount: Number,
  dividedAmount: Number,
  paymentStatus: {
    type: String,
    enum: ["pending", "paid"],
    default: "pending",
  },
  // Add other fields related to light bills
});

const LightBill = mongoose.model("LightBill", lightBillSchema);

module.exports = LightBill;
