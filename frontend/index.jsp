<!DOCTYPE html>
<html>
<head>
    <title>QR Voting Login</title>
</head>
<body>
    <h2>Login</h2>
    <input id="email" placeholder="Email">
    <input id="password" type="password" placeholder="Password">
    <button id="loginBtn">Login</button>

    <!-- Include your JS file -->
    <script src="js/ajaxCalls.js"></script>
    <script>
        // Make sure login function exists and bind it to the button
        document.getElementById("loginBtn").addEventListener("click", login);
    </script>
</body>
</html>

</html>
