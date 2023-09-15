const mongoose = require("mongoose");

const notificationSchema = new mongoose.Schema({
  recipientId: String, 
  content: String,
  date: Date,
});

const Notification = mongoose.model("Notification", notificationSchema);

module.exports = Notification;
