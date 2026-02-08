const QRCode = require('qrcode');

const generateQR = async (text) => {
    try {
        const qrData = await QRCode.toDataURL(text);
        return qrData;
    } catch (err) {
        console.error(err);
        return null;
    }
};

module.exports = generateQR;
