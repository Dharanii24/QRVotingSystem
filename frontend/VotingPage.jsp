<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Voting Page</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<h1>Welcome, <span id="userName"></span></h1>

<h2>Your QR Code</h2>
<img id="qrImage" src="" alt="Your QR Code" width="200">

<h2>Vote for a Candidate</h2>
<div id="candidates"></div>

<h2>Voting Results</h2>
<button onclick="viewResults()">View Results</button>
<div id="results"></div>

<script src="js/ajaxCalls.js"></script>
<script>
    // Display user name and QR code from sessionStorage
    document.getElementById('userName').innerText = sessionStorage.getItem('name');
    document.getElementById('qrImage').src = sessionStorage.getItem('qrCode');

    // Load candidates dynamically
    loadCandidates();
</script>
</body>
</html>
