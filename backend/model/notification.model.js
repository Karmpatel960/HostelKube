const mongoose = require("mongoose");

const notificationSchema = new mongoose.Schema({
  recipientId: String, // Student or Administrator ID
  content: String,
  date: Date,
});

const Notification = mongoose.model("Notification", notificationSchema);

module.exports = Notification;
