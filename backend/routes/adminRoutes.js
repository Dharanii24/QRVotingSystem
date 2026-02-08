const express = require('express');
const router = express.Router();
const { getCandidates, getResults } = require('../controllers/adminController');
const verifyToken = require('../middleware/authMiddleware');

router.get('/candidates', verifyToken, getCandidates);
router.get('/results', verifyToken, getResults);

module.exports = router;
