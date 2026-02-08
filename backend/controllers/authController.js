const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const generateQR = require('../utils/qrGenerator');
const User = require('../models/User');

exports.register = async (req, res) => {
    try {
        const { name, email, password } = req.body;

        const hashedPassword = await bcrypt.hash(password, 10);

        const qrData = `VOTER:${email}`;
        const qrFilename = `qr_${Date.now()}.png`;

        // Generate QR and get relative path
        const qrCodePath = await generateQR(qrData, qrFilename);

        User.create(name, email, hashedPassword, qrCodePath, (err) => {
            if (err) return res.status(500).json({ message: "DB error" });
            res.json({ message: "Registered successfully", qr: qrCodePath });
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Registration failed" });
    }
};

exports.login = (req, res) => {
    const { email, password } = req.body;

    User.findByEmail(email, async (err, results) => {
        if (err) return res.status(500).json({ message: err.message });
        if (results.length === 0) return res.status(404).json({ message: 'User not found' });

        const user = results[0];
        const match = await bcrypt.compare(password, user.password);
        if (!match) return res.status(401).json({ message: 'Incorrect password' });

        const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: '2h' });
        res.json({ token, qr: user.qr_code, name: user.name });
    });
};
