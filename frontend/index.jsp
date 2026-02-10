<form id="loginForm">
    <input type="email" name="email" placeholder="Email" required>
    <input type="password" name="password" placeholder="Password" required>
    <button type="submit">Login</button>
</form>

<div id="qrDisplay" style="display:none; margin-top:15px;">
    <h3>Welcome, <span id="userName"></span>!</h3>
    <img id="qrImg" width="200" alt="Your QR Code">
    <br>
    <a id="downloadQR" href="" download="voter_qr.png">Download QR</a>
    <p id="redirectMsg" style="color: green; margin-top: 10px;"></p>
</div>

<script>
document.getElementById("loginForm").addEventListener("submit", async e => {
    e.preventDefault();

    const formData = Object.fromEntries(new FormData(e.target));

    try {
        const res = await fetch("http://localhost:5000/api/auth/login", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(formData)
        });

        const data = await res.json();

        if (data.qrPath) {
            // Show name
            document.getElementById("userName").textContent = data.name;

            // Show QR code and download link
            document.getElementById("qrImg").src = "http://localhost:5000" + data.qrPath;
            document.getElementById("downloadQR").href = "http://localhost:5000" + data.qrPath;
            document.getElementById("qrDisplay").style.display = "block";

            // Message and auto-redirect
            const msg = document.getElementById("redirectMsg");
            msg.textContent = "Login successful! Redirecting to Voting page in 3 seconds...";

            setTimeout(() => {
                // Redirect to JSP Voting page (adjust port & path)
                window.location.href = "http://localhost:8080/QRVotingSystem/VotingPage.jsp?voterId=" + data.voterId + "&name=" + encodeURIComponent(data.name);
            }, 3000);

        } else {
            alert(data.error);
        }

    } catch (err) {
        console.error("Frontend login error:", err);
        alert("Server error during login");
    }
});
</script>
