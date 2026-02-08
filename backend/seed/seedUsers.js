// seed/seedUsers.js
const mongoose = require("mongoose");
const User = require("../models/User");

mongoose.connect(process.env.MONGO_URI);

(async () => {
  await User.deleteMany();

  for (let i = 0; i < 50; i++) {
    await User.create({
      name: `Responder ${i}`,
      verified: true,
      skills: i % 2 === 0 ? ["CPR"] : [],
      assets: i % 3 === 0 ? ["FireExtinguisher"] : [],
      location: {
        type: "Point",
        coordinates: [
          77.21 + Math.random() * 0.01,
          28.61 + Math.random() * 0.01
        ]
      }
    });
  }

  console.log("✅ Seed complete");
  process.exit();
})();
