// const express = require("express");
// const router = express.Router();
// const { getCandidates, addCandidate, results } = require("../controllers/adminController");

// router.get("/candidates", getCandidates);        // get candidate list
// router.post("/add-candidate", addCandidate);     // add new candidate
// router.get("/results", results);                 // get election results

// module.exports = router;


const express = require("express");
const router = express.Router();
const admin = require("../controllers/adminController");

router.get("/candidates", admin.getCandidates);
router.post("/add-candidate", admin.addCandidate);
router.get("/declare-winner", admin.declareWinner);
router.get("/rank-results", admin.rankResults);
router.get("/election-status", admin.getElectionStatus);
router.post("/election-status", admin.updateElectionStatus);
router.post("/login", admin.login);

module.exports = router;
