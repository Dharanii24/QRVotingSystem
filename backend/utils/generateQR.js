const QRCode = require("qrcode");
const fs = require("fs");
const path = require("path");

module.exports = async function generateQR(text) {
    const uploadDir = path.join(__dirname, "../uploads");

    if (!fs.existsSync(uploadDir)) {
        fs.mkdirSync(uploadDir);
    }

    const filename = `qr_${Date.now()}.png`;
    const filepath = path.join(uploadDir, filename);

    await QRCode.toFile(filepath, text);

    // return path usable by frontend
    return `/uploads/${filename}`;
};
