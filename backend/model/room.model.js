const mongoose = require("mongoose");

const roomSchema = new mongoose.Schema({
  roomNumber: String,
  totalBeds: Number, 
  occupiedBeds: {
    type: Number,
    default: 0, 
  },
});

const Room = mongoose.model("Room", roomSchema);

module.exports = Room;

