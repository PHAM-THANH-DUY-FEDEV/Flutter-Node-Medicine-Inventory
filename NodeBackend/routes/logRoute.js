const express = require("express");
const router = express.Router();
const logController = require("../controllers/logCtrl");

router.post("/user", logController.userLog);
module.exports = router;
