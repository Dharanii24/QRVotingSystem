const db = require('../config/db');
const User = require('../models/User');

exports.castVote = (req, res) => {
    const { candidateId } = req.body;
    const userId = req.userId; // from authMiddleware

    // 1️⃣ Check if user has already voted
    db.query("SELECT has_voted FROM Users WHERE id=?", [userId], (err, results) => {
        if (err) return res.status(500).json({ message: err.message });
        if (!results[0]) return res.status(404).json({ message: "User not found" });
        if (results[0].has_voted) return res.status(400).json({ message: "You have already voted" });

        // 2️⃣ Record vote
        db.query("INSERT INTO Votes (user_id, candidate_id) VALUES (?,?)", [userId, candidateId], (err2) => {
            if (err2) return res.status(500).json({ message: err2.message });

            // 3️⃣ Mark user as voted
            User.markVoted(userId, (err3) => {
                if (err3) return res.status(500).json({ message: err3.message });

                // 4️⃣ Increment candidate vote count
                db.query("UPDATE Candidates SET votes_count = votes_count + 1 WHERE id=?", [candidateId], (err4) => {
                    if (err4) return res.status(500).json({ message: err4.message });
                    res.json({ message: "Vote cast successfully" });
                });
            });
        });
    });
};
