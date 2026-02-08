// routes/panic.routes.js
const router = require("express").Router();
const Panic = require("../models/Panic");
const { findResponders } = require("../services/panic.service");

router.post("/trigger", async (req, res) => {
  const { type, lng, lat, userId } = req.body;

  const panic = await Panic.create({
    type,
    location: { type: "Point", coordinates: [lng, lat] },
    triggeredBy: userId
  });

  const responders = await findResponders(type, lng, lat);

  responders.forEach(r => {
    if (r.socketId) {
      req.io.to(r.socketId).emit("panic_alert", {
        panicId: panic._id,
        type,
        location: { lng, lat }
      });
    }
  });

  res.json({
    panicId: panic._id,
    responders: responders.length
  });
});

module.exports = router;
