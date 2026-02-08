// socket.js
const User = require("./models/User");
const Panic = require("./models/Panic");

module.exports = (io) => {
  io.on("connection", (socket) => {

    socket.on("register", async (userId) => {
      await User.findByIdAndUpdate(userId, { socketId: socket.id });
    });

    socket.on("accept_mission", async ({ panicId, userId }) => {
      await Panic.findByIdAndUpdate(panicId, {
        $push: { responders: { userId, status: "COMING" } }
      });

      io.emit("responder_update", { panicId });
    });

    socket.on("resolve_panic", async (panicId) => {
      await Panic.findByIdAndUpdate(panicId, { active: false });
      io.emit("panic_closed", panicId);
    });
  });
};
