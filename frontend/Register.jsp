
<form id="registerForm">
    <input type="text" name="name" placeholder="Full Name" required>
    <input type="email" name="email" placeholder="Email" required>
    <input type="password" name="password" placeholder="Password" required>
    <button type="submit">Register</button>
</form>

<script>
document.getElementById("registerForm").addEventListener("submit", async e => {
    e.preventDefault();
    const formData = Object.fromEntries(new FormData(e.target));

    try {
        const res = await fetch("http://localhost:5000/api/auth/register", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(formData)
        });

        const data = await res.json();

        if (data.success) {
            alert(data.message + "\nYour QR will be downloaded automatically.");

            // Auto-download QR
            const link = document.createElement("a");
            link.href = "http://localhost:5000" + data.qrPath;
            link.download = "voter_qr.png";
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);

            // Redirect to login page after 2 seconds
            setTimeout(() => {
                window.location.href = "index.jsp";
            }, 2000);

        } else {
            alert(data.error);
        }
    } catch (err) {
        console.error(err);
        alert("Server error during registration");
    }
});
</script>
