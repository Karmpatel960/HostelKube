const mongoose = require("mongoose");

const complaintSchema = new mongoose.Schema({
  studentId: String,
  submissionDate: Date,
  description: String,
  status: String, // "Open," "In Progress," "Resolved," etc.
  response: String, // Administrator's response
});

const Complaint = mongoose.model("Complaint", complaintSchema);

module.exports = Complaint;
