const express = require("express");
const router = express.Router();
const { scanQR, vote } = require("../controllers/voterController");

router.post("/scan", scanQR); // scan QR
router.post("/vote", vote);    // submit vote

module.exports = router;
