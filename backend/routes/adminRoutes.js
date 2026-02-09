const express = require("express");
const { getCandidates, addCandidate, viewResults } = require("../controllers/adminController");
const router = express.Router();

router.get("/candidates", getCandidates);
router.post("/add", addCandidate);
router.get("/results", viewResults);

module.exports = router;
