const db = require("../config/db");

// Save vote
exports.addVote = (userId, candidateId) => {
    return new Promise((resolve, reject) => {
        const sql = "INSERT INTO Votes (user_id, candidate_id) VALUES (?, ?)";
        db.query(sql, [userId, candidateId], (err, result) => {
            if (err) reject(err);
            else resolve(result);
        });
    });
};
