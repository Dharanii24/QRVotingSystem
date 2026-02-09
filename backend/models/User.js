const db = require("../config/db");

const User = {
    create: async (name, email, password, qr) => {
        const sql = `
            INSERT INTO users (name, email, password, qr_code)
            VALUES (?, ?, ?, ?)
        `;
        await db.query(sql, [name, email, password, qr]);
    },

    findByEmail: async (email) => {
        const [rows] = await db.query(
            "SELECT * FROM users WHERE email = ?",
            [email]
        );
        return rows;
    }
};

module.exports = User;
