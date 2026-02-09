const db = require("../config/db");

exports.getAll = cb => {
    db.query("SELECT * FROM Candidates", cb);
};

exports.add = (name, party, cb) => {
    db.query("INSERT INTO Candidates (name, party) VALUES (?,?)", [name, party], cb);
};

exports.incrementVote = (id, cb) => {
    db.query("UPDATE Candidates SET votes_count = votes_count + 1 WHERE id=?", [id], cb);
};
