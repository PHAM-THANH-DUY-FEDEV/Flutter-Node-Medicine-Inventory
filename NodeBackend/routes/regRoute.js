const express = require('express');
const router = express.Router();
const regController = require('../controllers/regCtrl');


router.post('/user', regController.userReg);

module.exports = router;