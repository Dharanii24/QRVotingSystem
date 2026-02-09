const db = require("../config/db");

exports.getCandidates = (req, res) => {
    db.query("SELECT * FROM Candidates", (e, r) => res.json(r));
};

exports.addCandidate = (req, res) => {
    const { name, party } = req.body;
    db.query("INSERT INTO Candidates(name,party) VALUES(?,?)", [name, party]);
    res.json({ message: "Candidate added" });
};

exports.results = (req, res) => {
    db.query("SELECT * FROM Candidates", (e, r) => res.json(r));
};
