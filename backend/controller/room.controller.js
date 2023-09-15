const cron = require("node-cron");
const RoomAllocation = require("./model/RoomAllocation.model");
const Room = require("./model/room.model");

cron.schedule("0 0 * * *", async () => {
  try {
    const expiredAllocations = await RoomAllocation.find({
      allocationDate: { $lt: new Date() }, 
    });

    for (const allocation of expiredAllocations) {
      await Room.findByIdAndUpdate(allocation.roomId, { status: "Empty" });
    }
  } catch (error) {
    console.error("Error updating room status:", error);
  }
});
cron.start();
