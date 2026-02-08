<!DOCTYPE html>
<html>
<head>
    <title>Voting Page</title>
</head>
<body>
    <h1>Welcome, <span id="name"></span></h1>
    <img id="qr" width="200" alt="Your QR Code">

    <h2>Candidates</h2>
    <div id="candidates"></div>

    <button id="viewResultsBtn">View Results</button>
    <div id="results"></div>

    <!-- Include your JS file -->
    <script src="js/ajaxCalls.js"></script>
    <script>
        // Load user info
        document.getElementById("name").innerText = sessionStorage.getItem("name") || "Voter";
        document.getElementById("qr").src = sessionStorage.getItem("qr") || "";

        // Load candidates from backend
        loadCandidates();

        // View results button
        document.getElementById("viewResultsBtn").addEventListener("click", viewResults);
    </script>
</body>
</html>
