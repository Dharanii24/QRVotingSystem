<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
</head>
<body>
    <h1>Admin Dashboard</h1>

    <h3>Add Candidate</h3>
    <input type="text" id="candidateName" placeholder="Name">
    <input type="text" id="candidateParty" placeholder="Party">
    <input type="text" id="candidateDescription" placeholder="Description">
    <button onclick="submitCandidate()">Add Candidate</button>

    <h3>Vote Results</h3>
    <button onclick="viewResults()">Refresh Results</button>
    <div id="results"></div>

    <script src="js/ajaxCalls.js"></script>
    <script>
        // Check admin login
        const token = sessionStorage.getItem("token");
        if (!token) {
            alert("Please login as admin!");
            window.location.href = "index.jsp";
        }

        // Function to submit candidate
        function submitCandidate() {
            const name = document.getElementById("candidateName").value;
            const party = document.getElementById("candidateParty").value;
            const description = document.getElementById("candidateDescription").value;

            if (!name || !party) {
                alert("Name and Party are required!");
                return;
            }

            addCandidate(name, party, description);
        }

        // Load results automatically
        viewResults();
    </script>
</body>
</html>
