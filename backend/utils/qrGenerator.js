const QRCode = require("qrcode");
const path = require("path");
const fs = require("fs");

module.exports = async function generateQR(text) {
    const uploadDir = path.join(__dirname, "../uploads");
    if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir);

    const filename = `qr_${Date.now()}.png`;
    const filePath = path.join(uploadDir, filename);

    await QRCode.toFile(filePath, text);
    return `/uploads/${filename}`; // return relative path
};
