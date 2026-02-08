// routes/user.routes.js
const router = require("express").Router();
const User = require("../models/User");

router.post("/update-location", async (req, res) => {
  const { userId, lng, lat } = req.body;

  await User.findByIdAndUpdate(userId, {
    location: { type: "Point", coordinates: [lng, lat] }
  });

  res.json({ success: true });
});

module.exports = router;
