const express = require("express");
const router = express.Router();
const databasseBillCtrl = require("../controllers/databaseBillCtrl");
const { authMiddleware } = require("../middlewares/authMiddleware");

router.get("/", authMiddleware, databasseBillCtrl.getBills);
router.get("/search-bills", databasseBillCtrl.searchBills);
router.get("/delete", databasseBillCtrl.deleteBill);
module.exports = router;
