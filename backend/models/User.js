const db = require('../config/db');

const User = {
    create: (name, email, password, qr_code, callback) => {
        const sql = "INSERT INTO Users (name,email,password,qr_code) VALUES (?,?,?,?)";
        db.query(sql, [name,email,password,qr_code], callback);
    },
    findByEmail: (email, callback) => {
        const sql = "SELECT * FROM Users WHERE email=?";
        db.query(sql, [email], callback);
    },
    markVoted: (userId, callback) => {
        const sql = "UPDATE Users SET has_voted=1 WHERE id=?";
        db.query(sql, [userId], callback);
    }
};

module.exports = User;
