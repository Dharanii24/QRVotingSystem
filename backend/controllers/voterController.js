const db = require("../config/db");

// QR Scan validation
exports.scanQR = async (req, res) => {
    try {
        const { qrData } = req.body;
        if (!qrData || !qrData.includes(":"))
            return res.status(400).json({ error: "Invalid QR format" });

        const email = qrData.split(":")[1];

        const [rows] = await db.query(
            "SELECT id, name, qr_code, has_voted FROM Users WHERE email=?",
            [email]
        );

        if (rows.length === 0) return res.status(404).json({ error: "Invalid QR Code" });
        if (rows[0].has_voted) return res.status(403).json({ error: "Already voted" });

        res.json({
            success: true,
            voterId: rows[0].id,
            name: rows[0].name,
            qr: rows[0].qr_code
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Server error" });
    }
};

// Submit vote
exports.vote = async (req, res) => {
    try {
        const { voterId, candidateId } = req.body;

        if (!voterId || !candidateId)
            return res.status(400).json({ error: "Voter ID and Candidate ID are required" });

        const [voterRows] = await db.query("SELECT has_voted FROM Users WHERE id=?", [voterId]);
        if (voterRows.length === 0) return res.status(404).json({ error: "Voter not found" });
        if (voterRows[0].has_voted) return res.status(400).json({ error: "Already voted" });

        await db.query("UPDATE Candidates SET votes_count = votes_count + 1 WHERE id=?", [candidateId]);
        await db.query("UPDATE Users SET has_voted = TRUE WHERE id=?", [voterId]);
        await db.query("INSERT INTO Votes(voter_id, candidate_id) VALUES (?, ?)", [voterId, candidateId]);

        res.json({ success: true, message: "Vote cast successfully" });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Server error" });
    }
};
