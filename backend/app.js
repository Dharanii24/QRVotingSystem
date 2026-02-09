// const path = require("path");
// require("dotenv").config({ path: path.join(__dirname, ".env") });

// console.log("ENV CHECK");
// console.log("DB_USER =", process.env.DB_USER);
// console.log("DB_PASS =", process.env.DB_PASS);

// const express = require("express");
// const cors = require("cors");

// const app = express();

// app.use(cors());
// app.use(express.json());
// app.use("/uploads", express.static(path.join(__dirname, "uploads")));

// app.use("/api/auth", require("./routes/authRoutes"));
// app.use("/api/voter", require("./routes/voterRoutes"));
// app.use("/api/admin", require("./routes/adminRoutes"));

// const PORT = process.env.PORT || 5000;
// app.listen(PORT, () => console.log("Server running on", PORT));


const path = require("path");
require("dotenv").config({ path: path.join(__dirname, ".env") });

const express = require("express");
const cors = require("cors");

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Serve uploads (QR images)
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

// Serve frontend static files
app.use(express.static(path.join(__dirname, "frontend"))); // <- frontend folder

// API routes
app.use("/api/auth", require("./routes/authRoutes"));
app.use("/api/voter", require("./routes/voterRoutes"));
app.use("/api/admin", require("./routes/adminRoutes"));

// Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log("Server running on", PORT));
