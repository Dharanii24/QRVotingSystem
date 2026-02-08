const db = require('../config/db');

// Get all candidates
exports.getCandidates = (req, res) => {
    db.query("SELECT * FROM Candidates", (err, results) => {
        if (err) return res.status(500).json({ message: err.message });
        res.json(results);
    });
};

// Get voting results
exports.getResults = (req, res) => {
    db.query("SELECT name, party, votes_count FROM Candidates", (err, results) => {
        if (err) return res.status(500).json({ message: err.message });
        res.json(results);
    });
};
