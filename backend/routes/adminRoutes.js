const express = require('express');
const router = express.Router();
const { addCandidate, removeCandidate, viewVotes } = require('../controllers/adminController');
const verifyToken = require('../middleware/authMiddleware');

// Admin endpoints
router.post('/add', verifyToken, addCandidate);
router.post('/remove', verifyToken, removeCandidate);
router.get('/votes', verifyToken, viewVotes);

module.exports = router;
