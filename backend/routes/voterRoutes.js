// const express = require("express");
// const router = express.Router();

// router.post("/scan", async (req, res) => {
//     res.json({ message: "Scan working" });
// });

// module.exports = router;


// const express = require("express");
// const router = express.Router();
// const pool = require("../config/db");

// router.post("/scan", async (req, res) => {
//     const { qrData } = req.body;

//     if (!qrData || !qrData.startsWith("VOTER:")) {
//         return res.status(400).json({ error: "Invalid QR code" });
//     }

//     const email = qrData.replace("VOTER:", "");

//     try {
//         const [rows] = await pool.query(
//             "SELECT has_voted FROM users WHERE email = ?",
//             [email]
//         );

//         if (rows.length === 0) {
//             return res.status(404).json({ error: "Voter not found" });
//         }

//         if (rows[0].has_voted) {
//             return res.status(403).json({ error: "Already voted" });
//         }

//         res.json({ success: true });

//     } catch (err) {
//         console.error(err);
//         res.status(500).json({ error: "Server error" });
//     }
// });

// module.exports = router;

const express = require("express");
const router = express.Router();
const pool = require("../config/db"); // your MySQL connection

// QR Scan Validation
router.post("/scan", async (req, res) => {
    const { qrData } = req.body; // should match JSON from frontend

    try {
        // Example: QR content = "VOTER:user@email.com"
        const email = qrData.split(":")[1]; 

        const [rows] = await pool.query(
            "SELECT id, has_voted FROM Users WHERE email = ?",
            [email]
        );

        if (rows.length === 0) {
            return res.status(404).json({ error: "Invalid QR Code" });
        }

        if (rows[0].has_voted) {
            return res.status(403).json({ error: "Already voted" });
        }

        res.json({ success: true, voterId: rows[0].id });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Server error" });
    }
});

module.exports = router;
