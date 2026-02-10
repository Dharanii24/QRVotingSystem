const db = require("../config/db");

// Get all candidates
exports.getCandidates = async (req, res) => {
    try {
        const [rows] = await db.query("SELECT id, name, party, votes_count FROM Candidates");
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Server error" });
    }
};


// Add a new candidate
exports.addCandidate = async (req, res) => {
    try {
        const { name, party } = req.body;

        if (!name || !party) {
            return res.status(400).json({ error: "Name and party are required" });
        }

        const [result] = await db.query(
            "INSERT INTO Candidates(name, party, votes_count) VALUES (?, ?, 0)",
            [name, party]
        );

        res.json({ success: true, message: "Candidate added", candidateId: result.insertId });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Server error" });
    }
};

// Get election results (ordered by votes)
exports.results = async (req, res) => {
    try {
        const [rows] = await db.query(
            "SELECT name, party, votes_count FROM Candidates ORDER BY votes_count DESC"
        );
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Server error" });
    }
};
