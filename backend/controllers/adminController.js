const db = require('../config/db');

// Add Candidate
const addCandidate = (req, res) => {
    const { name, party, description } = req.body;
    const sql = "INSERT INTO Candidates (name, party, description) VALUES (?,?,?)";
    db.query(sql, [name, party, description], (err) => {
        if(err) return res.status(500).json({ message: err.message });
        res.json({ message: "Candidate added successfully" });
    });
};

// Remove Candidate
const removeCandidate = (req, res) => {
    const { candidateId } = req.body;
    const sql = "DELETE FROM Candidates WHERE id=?";
    db.query(sql, [candidateId], (err) => {
        if(err) return res.status(500).json({ message: err.message });
        res.json({ message: "Candidate removed successfully" });
    });
};

// View all votes
const viewVotes = (req, res) => {
    const sql = `
        SELECT C.name as candidate, C.party, C.votes_count
        FROM Candidates C
        ORDER BY C.votes_count DESC
    `;
    db.query(sql, (err, results) => {
        if(err) return res.status(500).json({ message: err.message });
        res.json(results);
    });
};

module.exports = { addCandidate, removeCandidate, viewVotes };
