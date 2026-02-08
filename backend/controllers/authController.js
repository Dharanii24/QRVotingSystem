const User = require('../models/User');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const generateQR = require('../utils/qrGenerator');

const register = async (req, res) => {
    const { name, email, password } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);
    const qrCode = await generateQR(email + Date.now());

    User.create(name, email, hashedPassword, qrCode, (err, result) => {
        if(err) return res.status(500).json({ message: err.message });
        res.json({ message: 'User registered successfully', qrCode });
    });
};

const login = (req, res) => {
    const { email, password } = req.body;
    User.findByEmail(email, async (err, results) => {
        if(err) return res.status(500).json({ message: err.message });
        if(results.length === 0) return res.status(404).json({ message: 'User not found' });

        const user = results[0];
        const match = await bcrypt.compare(password, user.password);
        if(!match) return res.status(401).json({ message: 'Incorrect password' });

        const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: '2h' });
        res.json({ token, qrCode: user.qr_code, name: user.name });
    });
};

module.exports = { register, login };
