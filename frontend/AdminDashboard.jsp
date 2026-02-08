<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<h1>Admin Dashboard</h1>

<h2>Add Candidate</h2>
<input type="text" id="candName" placeholder="Candidate Name">
<input type="text" id="candParty" placeholder="Party">
<input type="text" id="candDesc" placeholder="Description">
<button onclick="addCandidate()">Add Candidate</button>

<h2>Remove Candidate</h2>
<input type="number" id="candIdRemove" placeholder="Candidate ID">
<button onclick="removeCandidate()">Remove Candidate</button>

<h2>Vote Results</h2>
<button onclick="viewResults()">View Votes</button>
<div id="voteResults"></div>

<script src="js/ajaxCalls.js"></script>
</body>
</html>
