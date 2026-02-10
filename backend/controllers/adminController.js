// const db = require("../config/db");

// // Get all candidates
// exports.getCandidates = async (req, res) => {
//     try {
//         const [rows] = await db.query("SELECT id, name, party, votes_count FROM Candidates");
//         res.json(rows);
//     } catch (err) {
//         console.error(err);
//         res.status(500).json({ error: "Server error" });
//     }
// };


// // Add a new candidate
// exports.addCandidate = async (req, res) => {
//     try {
//         const { name, party } = req.body;

//         if (!name || !party) {
//             return res.status(400).json({ error: "Name and party are required" });
//         }

//         const [result] = await db.query(
//             "INSERT INTO Candidates(name, party, votes_count) VALUES (?, ?, 0)",
//             [name, party]
//         );

//         res.json({ success: true, message: "Candidate added", candidateId: result.insertId });

//     } catch (err) {
//         console.error(err);
//         res.status(500).json({ error: "Server error" });
//     }
// };

// // Get election results (ordered by votes)
// exports.results = async (req, res) => {
//     try {
//         const [rows] = await db.query(
//             "SELECT name, party, votes_count FROM Candidates ORDER BY votes_count DESC"
//         );
//         res.json(rows);
//     } catch (err) {
//         console.error(err);
//         res.status(500).json({ error: "Server error" });
//     }
// };

const db = require("../config/db");

// Get candidates
exports.getCandidates = async (req, res) => {
    const [rows] = await db.query(
        "SELECT * FROM Candidates ORDER BY votes_count DESC"
    );
    res.json(rows);
};

// Add candidate
exports.addCandidate = async (req, res) => {
    const { name, party } = req.body;
    await db.query(
        "INSERT INTO Candidates (name, party) VALUES (?, ?)",
        [name, party]
    );
    res.json({ success: true, message: "Candidate Added" });
};

// Declare winner
exports.declareWinner = async (req, res) => {
    const [rows] = await db.query(
        "SELECT * FROM Candidates ORDER BY votes_count DESC LIMIT 1"
    );
    res.json({ success: true, winner: rows[0] });
};

// Rank wise
exports.rankResults = async (req, res) => {
    const [rows] = await db.query(
        "SELECT * FROM Candidates ORDER BY votes_count DESC"
    );
    res.json(rows);
};

// Get election status
exports.getElectionStatus = async (req, res) => {
    const [rows] = await db.query(
        "SELECT status FROM election_settings WHERE id=1"
    );
    res.json(rows[0]);
};

// Update election status
exports.updateElectionStatus = async (req, res) => {
    const { status } = req.body;
    await db.query(
        "UPDATE election_settings SET status=? WHERE id=1",
        [status]
    );
    res.json({ success: true });
};

// Admin login
exports.login = async (req, res) => {
    const { username, password } = req.body;
    const [rows] = await db.query(
        "SELECT * FROM admin WHERE username=? AND password=?",
        [username, password]
    );
    if (rows.length === 0) return res.json({ success: false });
    res.json({ success: true });
};
