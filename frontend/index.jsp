<!-- <h2>Login</h2>
<input id="email">
<input id="password" type="password">
<button onclick="login()">Login</button>
<a href="register.jsp">Register</a>
<script src="js/ajaxCalls.js"></script> -->
<!DOCTYPE html>
<html>
<head>
    <title>QR Voting Login</title>
</head>
<body>

<h2>Login</h2>

<input id="email" placeholder="Email"><br><br>
<input id="password" type="password" placeholder="Password"><br><br>

<button id="loginBtn">Login</button>

<script src="js/ajaxCalls.js"></script>

<script>
    // Bind login function AFTER JS is loaded
    document.getElementById("loginBtn").addEventListener("click", login);
</script>

</body>
</html>
