<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>QR Voting System - Login/Register</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <h1>QR Voting System</h1>

    <!-- Registration -->
    <h2>Register</h2>
    <input type="text" id="regName" placeholder="Name">
    <input type="email" id="regEmail" placeholder="Email">
    <input type="password" id="regPassword" placeholder="Password">
    <button onclick="registerUser()">Register</button>

    <hr>

    <!-- Login -->
    <h2>Login</h2>
    <input type="email" id="loginEmail" placeholder="Email">
    <input type="password" id="loginPassword" placeholder="Password">
    <button onclick="loginUser()">Login</button>

    <script src="js/ajaxCalls.js"></script>
</body>
</html>
