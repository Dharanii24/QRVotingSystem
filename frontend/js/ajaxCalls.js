const API = "http://localhost:5000/api";

// ================== LOGIN ==================
async function login() {
    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value;

    if (!email || !password) {
        alert("Please enter email and password");
        return;
    }

    try {
        const res = await fetch(`${API}/auth/login`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ email, password })
        });

        const data = await res.json();

        if (!res.ok) {
            alert(data.message || "Login failed");
            return;
        }

        sessionStorage.setItem("token", data.token);
        sessionStorage.setItem("name", data.name);
        sessionStorage.setItem("qr", data.qr);

        window.location.href = "VotingPage.jsp";
    } catch (err) {
        console.error(err);
        alert("Login request failed");
    }
}

// ================== LOAD CANDIDATES ==================
async function loadCandidates() {
    try {
        const res = await fetch(`${API}/admin/candidates`);
        if (!res.ok) throw new Error("Failed to fetch candidates");

        const data = await res.json();
        let html = "";

        data.forEach(c => {
            html += `
                <button onclick="vote(${c.id})">
                    Vote ${c.name} (${c.party})
                </button><br><br>
            `;
        });

        document.getElementById("candidates").innerHTML = html;
    } catch (err) {
        console.error(err);
        document.getElementById("candidates").innerHTML = "Failed to load candidates";
    }
}

// ================== CAST VOTE ==================
async function vote(candidateId) {
    const token = sessionStorage.getItem("token");
    if (!token) {
        alert("You must login first");
        return;
    }

    try {
        const res = await fetch(`${API}/voter/vote`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": token
            },
            body: JSON.stringify({ candidateId })
        });

        const data = await res.json();
        if (!res.ok) throw new Error(data.message || "Vote failed");

        alert(data.message);
        // Optionally reload results
    } catch (err) {
        console.error(err);
        alert(err.message);
    }
}

// ================== VIEW RESULTS ==================
async function viewResults() {
    try {
        const res = await fetch(`${API}/admin/results`);
        if (!res.ok) throw new Error("Failed to fetch results");

        const data = await res.json();
        let html = "<h3>Vote Count:</h3>";

        data.forEach(c => {
            html += `${c.name} (${c.party}) : ${c.votes_count} votes<br>`;
        });

        document.getElementById("results").innerHTML = html;
    } catch (err) {
        console.error(err);
        alert("Failed to load results");
    }
}
