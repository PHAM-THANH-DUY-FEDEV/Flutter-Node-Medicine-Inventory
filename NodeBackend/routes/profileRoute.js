const express = require("express");
const router = express.Router();
const { authMiddleware } = require("../middlewares/authMiddleware");
const ProfileController = require("../controllers/profileCtrl");

router.get("/profile", authMiddleware, ProfileController.getProfile);

module.exports = router;
