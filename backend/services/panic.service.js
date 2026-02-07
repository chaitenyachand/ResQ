// services/panic.service.js
const User = require("../models/User");

const RULES = {
  FIRE: { radius: 200, asset: "FireExtinguisher" },
  MEDICAL: { radius: 500, skill: "CPR" },
  SECURITY: { radius: 100 }
};
async function findResponders(type, lng, lat) {
  const rule = RULES[type];

  let query = {
    verified: true,
    location: {
      $near: {
        $geometry: {
          type: "Point",
          coordinates: [lng, lat]
        },
        $maxDistance: rule.radius
      }
    }
  };

  if (rule.skill) query.skills = rule.skill;
  if (rule.asset) query.assets = rule.asset;

  return await User.find(query).limit(10);
}

module.exports = { findResponders };
