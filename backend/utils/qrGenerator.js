// backend/utils/qrGenerator.js
const QRCode = require("qrcode");
const path = require("path");

async function generateVoterQR(email) {
    const qrData = `VOTER:${email}`;
    const fileName = `${email}.png`;
    const filePath = path.join(__dirname, "../uploads/", fileName);

    try {
        await QRCode.toFile(filePath, qrData);
        return `/uploads/${fileName}`; // URL for frontend
    } catch (err) {
        console.error("QR generation error:", err);
        return null;
    }
}

module.exports = { generateVoterQR };
