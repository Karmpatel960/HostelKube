const mongoose = require("mongoose");

const roomAllocationSchema = new mongoose.Schema({
  roomNumber: String,
  studentId: String,
  checkInDate: Date,
  checkOutDate: Date,
});

const RoomAllocation = mongoose.model("RoomAllocation", roomAllocationSchema);

module.exports = RoomAllocation;
