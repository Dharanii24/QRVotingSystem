// adminRoutes.js
const router = require("express").Router();
const c = require("../controllers/adminController");
router.get("/candidates", c.getCandidates);
router.post("/add", c.addCandidate);
router.get("/results", c.results);
module.exports = router;
