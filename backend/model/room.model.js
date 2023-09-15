const mongoose = require("mongoose");

const roomSchema = new mongoose.Schema({
  roomNumber: String,
  totalBeds: Number,           // Total number of beds in the room
  occupiedBeds: {
    type: Number,
    default: 0, // Set the initial value to 0
  },
  // Other room-related fields
});

const Room = mongoose.model("Room", roomSchema);

module.exports = Room;

