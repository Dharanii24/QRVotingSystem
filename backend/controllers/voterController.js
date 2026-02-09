const db = require("../config/db");

exports.vote = (req, res) => {
    const email = req.user.email;
    const { candidateId } = req.body;

    db.query("SELECT * FROM Users WHERE email=?", [email], (e, u) => {
        if (u[0].has_voted) return res.status(400).json({ message: "Already voted" });

        db.query("UPDATE Candidates SET votes_count=votes_count+1 WHERE id=?", [candidateId]);
        db.query("UPDATE Users SET has_voted=TRUE WHERE email=?", [email]);
        db.query("INSERT INTO Votes(user_email,candidate_id) VALUES(?,?)",
            [email, candidateId]);

        res.json({ message: "Vote cast successfully" });
    });
};
