console.log("ajaxCalls.js loaded");

// ================== REGISTER ==================
async function register() {
    const name = document.getElementById("name").value.trim();
    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value;

    if (!name || !email || !password) {
        alert("All fields are required");
        return;
    }

    try {
        const res = await fetch("http://localhost:5000/api/auth/register", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ name, email, password })
        });

        const data = await res.json();

        if (!res.ok) {
            alert(data.message || "Registration failed");
            return;
        }

        alert("Registration successful");
        window.location.href = "index.jsp";

    } catch (err) {
        console.error(err);
        alert("Backend not running");
    }
}

// ================== LOGIN ==================
// ================== LOGIN ==================
async function login() {
    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value;

    if (!email || !password) {
        alert("Email and password required");
        return;
    }

    try {
        const res = await fetch("http://localhost:5000/api/auth/login", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ email, password })
        });

        const data = await res.json();

        if (!res.ok) {
            alert(data.message || "Login failed");
            return;
        }

        // ✅ SAVE EVERYTHING
        localStorage.setItem("token", data.token);
        localStorage.setItem("name", data.name);
        localStorage.setItem("qr", data.qr);   // ⭐ THIS WAS MISSING

        alert("Login successful");
        window.location.href = "VotingPage.jsp";

    } catch (err) {
        console.error(err);
        alert("Login request failed");
    }
}
