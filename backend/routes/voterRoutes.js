const express = require("express");
const { vote } = require("../controllers/voterController");
const router = express.Router();

router.post("/vote", vote);

module.exports = router;
