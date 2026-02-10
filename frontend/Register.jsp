<head>
    <style>
    body {
        font-family: Arial, Helvetica, sans-serif;
        background: linear-gradient(135deg, #36b9cc, #4e73df);
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        margin: 0;
    }

    #registerForm {
        background: #ffffff;
        padding: 28px 32px;
        border-radius: 10px;
        box-shadow: 0 8px 22px rgba(0, 0, 0, 0.2);
        width: 340px;
        text-align: center;
    }

    #registerForm input {
        width: 100%;
        padding: 10px;
        margin: 9px 0;
        border: 1px solid #ccc;
        border-radius: 6px;
        font-size: 14px;
    }

    #registerForm input:focus {
        outline: none;
        border-color: #4e73df;
        box-shadow: 0 0 5px rgba(78, 115, 223, 0.5);
    }

    #registerForm button {
        width: 100%;
        padding: 10px;
        margin-top: 12px;
        background: #1cc88a;
        color: #ffffff;
        border: none;
        border-radius: 6px;
        font-size: 15px;
        cursor: pointer;
    }

    #registerForm button:hover {
        background: #17a673;
    }
</style>

</head>
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
