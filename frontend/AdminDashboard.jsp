<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - QR Voting</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        h2 { text-align: center; }
        #candidatesTable { width: 60%; margin: 20px auto; border-collapse: collapse; }
        #candidatesTable th, #candidatesTable td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        #candidatesTable th { background-color: #f0f0f0; }
        #addCandidateForm { width: 50%; margin: 20px auto; text-align: center; }
        #addCandidateForm input { padding: 8px; margin: 5px; }
        #message { text-align: center; font-weight: bold; }
    </style>
</head>
<body>

<h2>Admin Dashboard - QR Voting System</h2>

<!-- Candidate Table -->
<table id="candidatesTable">
    <thead>
        <tr>
            <th>Candidate Name</th>
            <th>Party</th>
            <th>Votes</th>
        </tr>
    </thead>
    <tbody id="candidatesBody">
        <!-- Candidates will be loaded here dynamically -->
    </tbody>
</table>

<!-- Add Candidate Form -->
<div id="addCandidateForm">
    <h3>Add New Candidate</h3>
    <input type="text" id="candidateName" placeholder="Candidate Name" />
    <input type="text" id="candidateParty" placeholder="Party" />
    <button id="addCandidateBtn">Add Candidate</button>
</div>

<p id="message"></p>

<script>
const candidatesBody = document.getElementById("candidatesBody");
const message = document.getElementById("message");

// Fetch candidates and update table
async function loadCandidates() {
    try {
        const res = await fetch("http://localhost:5000/api/admin/candidates");
        const data = await res.json();

        candidatesBody.innerHTML = ""; // clear table
        data.forEach(c => {
            const row = document.createElement("tr");
            row.innerHTML = `
                <td>${c.name}</td>
                <td>${c.party}</td>
                <td>${c.votes_count}</td>
            `;
            candidatesBody.appendChild(row);
        });
    } catch (err) {
        console.error(err);
        message.style.color = "red";
        message.innerText = "Failed to load candidates";
    }
}

// Add new candidate
document.getElementById("addCandidateBtn").addEventListener("click", async () => {
    const name = document.getElementById("candidateName").value.trim();
    const party = document.getElementById("candidateParty").value.trim();

    if (!name || !party) {
        alert("Please enter both name and party");
        return;
    }

    try {
        const res = await fetch("http://localhost:5000/api/admin/add-candidate", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ name, party })
        });

        const data = await res.json();
        if (data.success) {
            message.style.color = "green";
            message.innerText = data.message;
            document.getElementById("candidateName").value = "";
            document.getElementById("candidateParty").value = "";
            loadCandidates(); // refresh table
        } else {
            message.style.color = "red";
            message.innerText = data.error;
        }
    } catch (err) {
        console.error(err);
        message.style.color = "red";
        message.innerText = "Server error";
    }
});

// Auto-refresh candidates every 5 seconds to simulate live results
setInterval(loadCandidates, 5000);

// Initial load
loadCandidates();
</script>

</body>
</html>
