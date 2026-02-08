const db = require("../config/db");

// Get all candidates
exports.getAllCandidates = () => {
    return new Promise((resolve, reject) => {
        db.query("SELECT * FROM Candidates", (err, results) => {
            if (err) reject(err);
            else resolve(results);
        });
    });
};

// Get voting results
exports.getResults = () => {
    return new Promise((resolve, reject) => {
        db.query(
            "SELECT name, party, votes_count FROM Candidates",
            (err, results) => {
                if (err) reject(err);
                else resolve(results);
            }
        );
    });
};
