const db = require("../config/db");

exports.create = (name, email, password, qr, cb) => {
    db.query(
        "INSERT INTO Users (name,email,password,qr_code) VALUES (?,?,?,?)",
        [name, email, password, qr],
        cb
    );
};

exports.findByEmail = (email, cb) => {
    db.query("SELECT * FROM Users WHERE email=?", [email], cb);
};

exports.markVoted = (email, cb) => {
    db.query("UPDATE Users SET has_voted=TRUE WHERE email=?", [email], cb);
};
