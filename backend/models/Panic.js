// models/Panic.js
const mongoose = require("mongoose");

const PanicSchema = new mongoose.Schema({
  type: {
    type: String,
    enum: ["FIRE", "MEDICAL", "SECURITY"]
  },

  location: {
    type: { type: String, default: "Point" },
    coordinates: [Number]
  },

  triggeredBy: mongoose.Schema.Types.ObjectId,

  responders: [{
    userId: mongoose.Schema.Types.ObjectId,
    status: String
  }],

  active: { type: Boolean, default: true },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model("Panic", PanicSchema);
