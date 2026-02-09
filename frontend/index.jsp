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
<button onclick="window.location.href='register.jsp'">Register</button>

<script src="js/ajaxCalls.js"></script>
<script>
    document.getElementById("loginBtn").addEventListener("click", login);
</script>
</body>
</html>
