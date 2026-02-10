const express = require("express");
const router = express.Router();
const { getCandidates, addCandidate, results } = require("../controllers/adminController");

router.get("/candidates", getCandidates);        // get candidate list
router.post("/add-candidate", addCandidate);     // add new candidate
router.get("/results", results);                 // get election results

module.exports = router;
