const express = require("express");
const router = express.Router();
const databasseMedicinCtrl = require("../controllers/databaseMedicinCtrl");
const { authMiddleware } = require("../middlewares/authMiddleware");
const upload = require("../middlewares/uploadMiddleware");

router.get("/lib", authMiddleware, databasseMedicinCtrl.getMedicinsOfLib);
router.get("/search-medicins-lib", databasseMedicinCtrl.searchMedicinsLib);
router.post(
  "/add",
  authMiddleware,
  upload.single("image"),
  databasseMedicinCtrl.addMedicin,
);
router.post(
  "/edit",
  authMiddleware,
  upload.single("image"),
  databasseMedicinCtrl.editMedicin,
);
router.get("/delete", authMiddleware, databasseMedicinCtrl.deleteMedicin);
// router.get('/lib', getDataController.getMedicinsOfLib)
module.exports = router;
