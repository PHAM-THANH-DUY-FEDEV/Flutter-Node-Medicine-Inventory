const express = require('express');
const router = express.Router();
const statisCtrl = require('../controllers/statisCtrl');


router.get('/', statisCtrl.getStatis);
router.get('/category', statisCtrl.getStatisWithCategory);
module.exports = router;