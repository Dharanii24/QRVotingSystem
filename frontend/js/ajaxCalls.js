const API = "http://localhost:5000/api";

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
                "Authorization": `Bearer ${token}` // ✅ send token
            },
            body: JSON.stringify({ candidateId })
        });

        const data = await res.json();
        if (!res.ok) throw new Error(data.message || "Vote failed");

        alert(data.message);
        viewResults(); // reload results
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
