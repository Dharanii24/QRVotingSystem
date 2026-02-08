const express = require('express');
const router = express.Router();
const { castVote } = require('../controllers/voterController');
const verifyToken = require('../middleware/authMiddleware');

router.post('/vote', verifyToken, castVote);

module.exports = router;
