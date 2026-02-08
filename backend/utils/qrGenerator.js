const QRCode = require("qrcode");
const path = require("path");
const fs = require("fs");

const generateQR = async (text, filename) => {
    const uploadDir = path.join(__dirname, "../uploads");

    // create uploads folder if missing
    if (!fs.existsSync(uploadDir)) {
        fs.mkdirSync(uploadDir);
    }

    const filePath = path.join(uploadDir, filename);
    await QRCode.toFile(filePath, text);

    // Return path relative to server root
    return `/uploads/${filename}`;
};

module.exports = generateQR;
