<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Voting Page</title>
    <script src="https://unpkg.com/html5-qrcode"></script>
    <style>
        body { font-family: Arial; text-align: center; padding: 20px; }
        #candidateButtons button { margin: 5px; padding: 10px; cursor: pointer; color: black; font-size:16px; }
        .selected { background-color: #c8e6c9; }
        .disabled { background-color: #eee; cursor: not-allowed; }
        #message { margin-top: 15px; font-weight: bold; }
        #reader { width: 300px; margin: auto; }
        #candidateSection { display: none; }
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

        candidates.forEach(c => {
            console.log("Candidate object:", c); // DEBUG
            if (!c.name) return;

            const btn = document.createElement("button");
            btn.innerText = `${c.name} (${c.party})`;
            btn.dataset.id = c.id;
            btn.classList.add("candidate-btn");

            btn.addEventListener("click", () => {
                selectedCandidateId = c.id;
                document.querySelectorAll(".candidate-btn").forEach(b => b.classList.remove("selected"));
                btn.classList.add("selected");
                document.getElementById("submitVote").disabled = false;
            });

            container.appendChild(btn);
        });
    } catch (err) {
        console.error(err);
        messageEl.style.color = "red";
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
