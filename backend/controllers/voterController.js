const db = require("../config/db");
const jwt = require("jsonwebtoken");

exports.vote = (req, res) => {
    const authHeader = req.headers.authorization;
    if (!authHeader) return res.status(401).json({ message: "No token provided" });

    const token = authHeader.split(" ")[1];
    if (!token) return res.status(401).json({ message: "Invalid token" });

    let decoded;
    try { decoded = jwt.verify(token, process.env.JWT_SECRET); }
    catch { return res.status(401).json({ message: "Invalid token" }); }

    const email = decoded.email;
    const candidateId = req.body.candidateId;
    if (!candidateId) return res.status(400).json({ message: "Candidate ID required" });

    db.query("SELECT * FROM Users WHERE email=?", [email], (err, users) => {
        if (err) return res.status(500).json({ message: "DB error" });
        if (!users.length) return res.status(404).json({ message: "Voter not found" });

        const voter = users[0];
        if (voter.has_voted) return res.status(400).json({ message: "Already voted" });

        db.query("UPDATE Candidates SET votes_count = votes_count + 1 WHERE id=?", [candidateId], (err2) => {
            if (err2) return res.status(500).json({ message: "DB error" });

            db.query("UPDATE Users SET has_voted=TRUE WHERE email=?", [email], (err3) => {
                if (err3) return res.status(500).json({ message: "DB error" });
                res.json({ message: "Vote successfully cast!" });
            });
        });
    });
};
