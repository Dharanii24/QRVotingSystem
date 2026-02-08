const db = require('../config/db');
const User = require('../models/User');

// Cast a vote
const castVote = (req, res) => {
    const { candidateId } = req.body;
    const userId = req.userId;

    // Check if user already voted
    const checkVoteSQL = "SELECT has_voted FROM Users WHERE id=?";
    db.query(checkVoteSQL, [userId], (err, results) => {
        if(err) return res.status(500).json({ message: err.message });
        if(results[0].has_voted) return res.status(400).json({ message: "You have already voted" });

        // Record vote
        const voteSQL = "INSERT INTO Votes (user_id, candidate_id) VALUES (?,?)";
        db.query(voteSQL, [userId, candidateId], (err2) => {
            if(err2) return res.status(500).json({ message: err2.message });

            // Mark user as voted
            User.markVoted(userId, (err3) => {
                if(err3) return res.status(500).json({ message: err3.message });

                // Increment candidate votes
                const updateCandidateSQL = "UPDATE Candidates SET votes_count = votes_count + 1 WHERE id=?";
                db.query(updateCandidateSQL, [candidateId], (err4) => {
                    if(err4) return res.status(500).json({ message: err4.message });
                    res.json({ message: "Vote cast successfully" });
                });
            });
        });
    });
};

module.exports = { castVote };
