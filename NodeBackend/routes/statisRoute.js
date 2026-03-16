const express = require("express");
const router = express.Router();
const statisCtrl = require("../controllers/statisCtrl");
const authMiddleware = require("../middlewares/authMiddleware");

router.get("/", authMiddleware.authMiddleware, statisCtrl.getStatis);
router.get("/category", statisCtrl.getStatisWithCategory);
module.exports = router;
