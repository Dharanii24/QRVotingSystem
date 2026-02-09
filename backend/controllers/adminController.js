const Candidate = require("../models/Candidate");

exports.getCandidates = (req, res) => {
    Candidate.getAll((err, results) => {
        if (err) return res.status(500).json({ message: "DB error" });
        res.json(results);
    });
};

exports.addCandidate = (req, res) => {
    const { name, party } = req.body;
    if (!name || !party) return res.status(400).json({ message: "All fields required" });

    Candidate.add(name, party, (err) => {
        if (err) return res.status(500).json({ message: "DB error" });
        res.json({ message: "Candidate added successfully" });
    });
};

exports.viewResults = (req, res) => {
    Candidate.getAll((err, results) => {
        if (err) return res.status(500).json({ message: "DB error" });
        res.json(results);
    });
};
