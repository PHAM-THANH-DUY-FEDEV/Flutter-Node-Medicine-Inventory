const express = require('express');
const router = express.Router();
const logController = require('../controllers/logCtrl');

router.post('/user', logController.userLog);
router.post('/token', logController.checkToken)
module.exports = router;