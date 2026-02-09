<!DOCTYPE html>
<html>
<head>
    <title>QR Voting Register</title>
</head>
<body>
<h2>Register</h2>
<input id="name" placeholder="Name">
<input id="email" placeholder="Email">
<input id="password" type="password" placeholder="Password">
<button id="registerBtn">Register</button>

<script src="js/ajaxCalls.js"></script>
<script>
document.getElementById("registerBtn").addEventListener("click", register);
</script>
</body>
</html>
