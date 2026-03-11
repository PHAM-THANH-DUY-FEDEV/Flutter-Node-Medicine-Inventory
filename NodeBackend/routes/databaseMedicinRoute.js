const express = require('express');
const router = express.Router();
const databasseMedicinCtrl = require('../controllers/databaseMedicinCtrl');


router.get('/lib', databasseMedicinCtrl.getMedicinsOfLib);
router.get("/search-medicins-lib", databasseMedicinCtrl.searchMedicinsLib);
router.post("/add", databasseMedicinCtrl.addMedicin)
router.post("/edit", databasseMedicinCtrl.editMedicin)
router.get("/delete", databasseMedicinCtrl.deleteMedicin)
// router.get('/lib', getDataController.getMedicinsOfLib)
module.exports = router;