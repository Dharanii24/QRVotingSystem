<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Voting Page</title>
    <script src="https://unpkg.com/html5-qrcode"></script>
    
       <style>
    body {
        font-family: Arial, Helvetica, sans-serif;
        background: linear-gradient(135deg, #f8f9fc, #e3e6f0);
        text-align: center;
        padding: 20px;
        margin: 0;
    }

    h2, h3 {
        color: #2e59d9;
    }

    #welcome {
        margin-bottom: 10px;
    }

    #scanMsg {
        font-size: 15px;
        color: #555;
        margin-bottom: 15px;
    }

    #reader {
        width: 320px;
        margin: 15px auto;
        padding: 10px;
        background: #ffffff;
        border-radius: 10px;
        box-shadow: 0 6px 18px rgba(0, 0, 0, 0.15);
    }

    #qrImg {
        margin-top: 10px;
        border: 4px solid #4e73df;
        border-radius: 10px;
    }

    #candidateSection {
        margin-top: 25px;
        padding: 20px;
        background: #ffffff;
        border-radius: 12px;
        box-shadow: 0 8px 22px rgba(0, 0, 0, 0.15);
        display: none;
    }

    #candidateButtons {
        margin-top: 15px;
    }

    #candidateButtons button {
        margin: 8px;
        padding: 12px 18px;
        cursor: pointer;
        font-size: 15px;
        border-radius: 8px;
        border: 1px solid #ccc;
        background: #f8f9fc;
        transition: 0.2s;
    }

    #candidateButtons button:hover {
        background: #e2e6ea;
    }

    .selected {
        background-color: #1cc88a !important;
        color: white;
        border-color: #1cc88a;
    }

    .disabled {
        background-color: #eee;
        cursor: not-allowed;
        opacity: 0.6;
    }

    #submitVote {
        margin-top: 20px;
        padding: 12px 25px;
        font-size: 16px;
        background: #4e73df;
        color: white;
        border: none;
        border-radius: 8px;
        cursor: pointer;
    }

    #submitVote:disabled {
        background: #b7b9cc;
        cursor: not-allowed;
    }

    #submitVote:hover:not(:disabled) {
        background: #2e59d9;
    }

    #message {
        margin-top: 18px;
        font-weight: bold;
        font-size: 15px;
    }

    </style>
</head>
<body>

<h2 id="welcome">Welcome</h2>
<img id="qrImg" width="200" style="display:none;">
<p id="scanMsg">Scan your QR code to authenticate:</p>

<div id="reader"></div>

<div id="candidateSection">
    <h3>Select Your Candidate</h3>
    <div id="candidateButtons"></div>
    <button id="submitVote" disabled>Submit Vote</button>
</div>

<p id="message"></p>

<script>
let voterId = null;
let selectedCandidateId = null;
const messageEl = document.getElementById("message");

// ----------------------
// 1️⃣ QR Scanner
// ----------------------
function onScanSuccess(decodedText) {
    fetch("http://localhost:5000/api/voter/scan", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ qrData: decodedText })
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            voterId = data.voterId;
            document.getElementById("welcome").innerText = "Welcome, " + data.name;
            document.getElementById("qrImg").src = "http://localhost:5000" + data.qr;
            document.getElementById("qrImg").style.display = "block";

            messageEl.style.color = "green";
            messageEl.innerText = "QR validated successfully! You can now vote.";

            // Show candidates after QR validation
            document.getElementById("candidateSection").style.display = "block";
            loadCandidates(); // Load candidates dynamically
        } else {
            messageEl.style.color = "red";
            messageEl.innerText = data.error;
        }
    })
    .catch(err => {
        console.error(err);
        messageEl.style.color = "red";
        messageEl.innerText = "Server error during QR scan";
    });
}

// Start camera scanner
new Html5Qrcode("reader").start(
    { facingMode: "environment" },
    { fps: 10, qrbox: 250 },
    onScanSuccess
);

// ----------------------
// 2️⃣ Load candidates
// ----------------------
async function loadCandidates() {
    try {
        const res = await fetch("http://localhost:5000/api/admin/candidates");
        const candidates = await res.json();

        const container = document.getElementById("candidateButtons");
        container.innerHTML = "";

        candidates.forEach(function(c) {
            console.log("Candidate:", c);

            const btn = document.createElement("button");
            btn.innerText = c.name + " (" + c.party + ")"; // ✅ FIX
            btn.className = "candidate-btn";
            btn.dataset.id = c.id;

            btn.onclick = function () {
                selectedCandidateId = c.id;
                document.querySelectorAll(".candidate-btn")
                    .forEach(b => b.classList.remove("selected"));
                btn.classList.add("selected");
                document.getElementById("submitVote").disabled = false;
            };

            container.appendChild(btn);
        });

    } catch (err) {
        console.error(err);
        messageEl.innerText = "Failed to load candidates";
    }
}

// ----------------------
// 3️⃣ Submit Vote
// ----------------------
document.getElementById("submitVote").addEventListener("click", async () => {
    if (!voterId || !selectedCandidateId) {
        messageEl.style.color = "red";
        messageEl.innerText = "Voter ID and Candidate ID are required";
        return;
    }

    try {
        const res = await fetch("http://localhost:5000/api/voter/vote", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ voterId, candidateId: selectedCandidateId })
        });
        const data = await res.json();

        if (data.success) {
            messageEl.style.color = "green";
            messageEl.innerText = data.message + " Redirecting to Register page...";
            
            // Disable all buttons after vote
            document.getElementById("submitVote").disabled = true;
            document.querySelectorAll(".candidate-btn").forEach(b => b.disabled = true);

            // Redirect after 3 seconds
            setTimeout(() => {
                window.location.href = "http://localhost:8080/QRVotingSystem/register.jsp";
            }, 3000);
        } else {
            messageEl.style.color = "red";
            messageEl.innerText = data.error;
        }
    } catch (err) {
        console.error(err);
        messageEl.style.color = "red";
        messageEl.innerText = "Server error during vote submission";
    }
});
</script>

</body>
</html>
