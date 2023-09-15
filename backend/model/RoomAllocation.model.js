const mongoose = require("mongoose");

const roomAllocationSchema = new mongoose.Schema({
    adminId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "user", // Reference to the admin who allocated the room
      required: true,
    },
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "user", // Reference to the user being allocated the room
      required: true,
    },
    roomId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Room", // Reference to the room being allocated
      required: true,
    },
    allocationDate: {
      type: Date,
      default: Date.now,
    },
    status: String,
  });
  

const RoomAllocation = mongoose.model("RoomAllocation", roomAllocationSchema);

module.exports = RoomAllocation;