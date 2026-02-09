const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const generateQR = require("../utils/qrGenerator");
const User = require("../models/User");

exports.register = async (req, res) => {
    try {
        const { name, email, password } = req.body;
        if (!name || !email || !password)
            return res.status(400).json({ message: "All fields required" });

        const hashedPassword = await bcrypt.hash(password, 10);
        const qrCode = await generateQR(`VOTER:${email}`);

        User.create(name, email, hashedPassword, qrCode, (err) => {
            if (err) return res.status(500).json({ message: "DB error" });
            res.json({ message: "Registered successfully" });
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Registration failed" });
    }
};

exports.login = (req, res) => {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ message: "All fields required" });

    User.findByEmail(email, async (err, results) => {
        if (err) return res.status(500).json({ message: "DB error" });
        if (!results.length) return res.status(404).json({ message: "User not found" });

        const user = results[0];
        const match = await bcrypt.compare(password, user.password);
        if (!match) return res.status(401).json({ message: "Incorrect password" });

        const token = jwt.sign({ email: user.email }, process.env.JWT_SECRET, { expiresIn: "1h" });
        res.json({ token, name: user.name, qr: user.qr_code });
    });
};
