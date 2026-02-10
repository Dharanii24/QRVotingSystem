

const db = require("../config/db");
const { generateVoterQR } = require("../utils/qrGenerator");
const path = require("path");
const bcrypt = require("bcrypt"); // optional if you hash passwords
exports.register = async (req, res) => {
    const { name, email, password } = req.body;

    try {
        // 1️⃣ Save user in DB
        await db.query(
            "INSERT INTO Users(name, email, password, has_voted) VALUES (?, ?, ?, ?)",
            [name, email, password, false]
        );

        // 2️⃣ Generate QR code
        const qrPath = await generateVoterQR(email);

        // 3️⃣ Save QR path in DB
        await db.query("UPDATE Users SET qr_code=? WHERE email=?", [qrPath, email]);

        // 4️⃣ Return success + QR path
        res.json({
            success: true,
            message: "Registration successful!",
            qrPath: qrPath // for frontend download
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Server error during registration" });
    }
};


exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ error: "Email and password are required" });
        }

        // Query user by email
        const [rows] = await db.query(
            "SELECT id, name, email, password, qr_code, has_voted FROM Users WHERE email = ?",
            [email]
        );

        if (rows.length === 0) {
            return res.status(404).json({ error: "User not found" });
        }

        const user = rows[0];

        // Check password
        // If you use plain text (not recommended):
        if (password !== user.password) {
            return res.status(401).json({ error: "Incorrect password" });
        }

        // If you use bcrypt hashed passwords:
        // const match = await bcrypt.compare(password, user.password);
        // if (!match) return res.status(401).json({ error: "Incorrect password" });

        // Return QR path and user info
        res.json({
            success: true,
            message: "Login successful",
            name: user.name,
            voterId: user.id,
            qrPath: "/uploads/" + user.qr_code
        });

    } catch (err) {
        console.error("Login Error:", err);
        res.status(500).json({ error: "Server error during login" });
    }
};
