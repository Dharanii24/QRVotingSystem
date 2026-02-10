
<head><style>
    body {
        font-family: Arial, Helvetica, sans-serif;
        background: linear-gradient(135deg, #4e73df, #1cc88a);
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        margin: 0;
    }

    form {
        background: #ffffff;
        padding: 25px 30px;
        border-radius: 10px;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
        width: 320px;
        text-align: center;
    }

    form input {
        width: 100%;
        padding: 10px;
        margin: 8px 0;
        border: 1px solid #ccc;
        border-radius: 6px;
        font-size: 14px;
    }

    form input:focus {
        outline: none;
        border-color: #4e73df;
        box-shadow: 0 0 4px rgba(78, 115, 223, 0.5);
    }

    form button {
        width: 100%;
        padding: 10px;
        background: #4e73df;
        color: #fff;
        border: none;
        border-radius: 6px;
        font-size: 15px;
        cursor: pointer;
        margin-top: 10px;
    }

    form button:hover {
        background: #2e59d9;
    }

    #qrDisplay {
        background: #ffffff;
        padding: 25px;
        border-radius: 10px;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
        text-align: center;
        margin-left: 20px;
    }

    #qrDisplay h3 {
        margin-bottom: 10px;
        color: #333;
    }

    #qrImg {
        margin: 10px 0;
        border: 4px solid #4e73df;
        border-radius: 8px;
    }

    #downloadQR {
        display: inline-block;
        margin-top: 10px;
        text-decoration: none;
        background: #1cc88a;
        color: #fff;
        padding: 8px 15px;
        border-radius: 6px;
        font-size: 14px;
    }

    #downloadQR:hover {
        background: #17a673;
    }

    #redirectMsg {
        font-size: 14px;
        font-weight: bold;
    }
</style>
</head>
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
