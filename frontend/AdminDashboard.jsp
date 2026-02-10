<%
if(session.getAttribute("admin")==null){
    response.sendRedirect("adminLogin.jsp");
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Dashboard</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body{
    margin:0;
    font-family:Segoe UI, Arial;
    background:#f1f5f9;
}
.header{
    background:#0f172a;
    color:white;
    padding:15px 30px;
    display:flex;
    justify-content:space-between;
    align-items:center;
}
.logout{
    background:#ef4444;
    border:none;
    color:white;
    padding:8px 16px;
    cursor:pointer;
}
.container{
    padding:30px;
    text-align:center;
}
button{
    padding:8px 14px;
    margin:4px;
    border:none;
    cursor:pointer;
}
.start{background:#22c55e;color:white;}
.stop{background:#f97316;color:white;}
.add{background:#3b82f6;color:white;}
.delete{background:#dc2626;color:white;}
input{
    padding:8px;
    margin:5px;
    width:180px;
}
table{
    width:80%;
    margin:auto;
    background:white;
    border-collapse:collapse;
}
th{
    background:#1e293b;
    color:white;
    padding:10px;
}
td{
    padding:10px;
    border-bottom:1px solid #e5e7eb;
}
#winner{
    font-size:18px;
    font-weight:bold;
    margin-top:10px;
    color:#16a34a;
}
canvas{
    margin-top:30px;
}
</style>
</head>

<body>

<div class="header">
    <h2>Admin Dashboard</h2>
    <button class="logout" onclick="logout()">Logout</button>
</div>

<div class="container">

<button class="start" onclick="setStatus('OPEN')">Start Election</button>
<button class="stop" onclick="setStatus('CLOSED')">Stop Election</button>

<hr>

<h3>Add Candidate</h3>
<input id="cname" placeholder="Candidate Name">
<input id="cparty" placeholder="Party Name">
<button class="add" onclick="addCandidate()">Add</button>

<hr>

<h3>Live Results</h3>
<table>
<thead>
<tr>
<th>Rank</th>
<th>Name</th>
<th>Party</th>
<th>Votes</th>
<th>Action</th>
</tr>
</thead>
<tbody id="body"></tbody>
</table>

<br>
<button class="start" onclick="declareWinner()">Declare Winner</button>
<p id="winner"></p>

<canvas id="chart" width="700"></canvas>

</div>

<script>
var body = document.getElementById("body");
var winner = document.getElementById("winner");
var chart = null;

/* LOAD DATA */
function loadData(){
fetch("http://localhost:5000/api/admin/rank-results")
.then(function(res){ return res.json(); })
.then(function(data){

    body.innerHTML = "";

    var names = [];
    var votes = [];

    for(var i=0;i<data.length;i++){

        var c = data[i];
        var name  = c.name;
        var party = c.party;
        var vote  = c.votes_count;

        body.innerHTML +=
            "<tr>" +
            "<td>"+(i+1)+"</td>" +
            "<td>"+name+"</td>" +
            "<td>"+party+"</td>" +
            "<td>"+vote+"</td>" +
            "<td><button class='delete' onclick='removeCandidate("+c.id+")'>Delete</button></td>" +
            "</tr>";

        names.push(name);
        votes.push(vote);
    }

    if(chart) chart.destroy();

    chart = new Chart(document.getElementById("chart"),{
        type:"bar",
        data:{
            labels:names,
            datasets:[{
                label:"Votes",
                data:votes
            }]
        }
    });
});
}

/* ADD CANDIDATE */
function addCandidate(){
fetch("http://localhost:5000/api/admin/add-candidate",{
    method:"POST",
    headers:{ "Content-Type":"application/json" },
    body:JSON.stringify({
        name:cname.value,
        party:cparty.value
    })
}).then(function(){
    cname.value="";
    cparty.value="";
    loadData();
});
}

/* DELETE CANDIDATE */
function removeCandidate(id){
if(!confirm("Remove this candidate?")) return;

fetch("http://localhost:5000/api/admin/remove-candidate",{
    method:"POST",
    headers:{ "Content-Type":"application/json" },
    body:JSON.stringify({ id:id })
}).then(function(){
    loadData();
});
}

/* ELECTION STATUS */
function setStatus(status){
fetch("http://localhost:5000/api/admin/election-status",{
    method:"POST",
    headers:{ "Content-Type":"application/json" },
    body:JSON.stringify({ status:status })
}).then(function(){
    alert("Election " + status);
});
}

/* DECLARE WINNER */
function declareWinner(){
fetch("http://localhost:5000/api/admin/declare-winner")
.then(function(res){ return res.json(); })
.then(function(d){
    winner.innerHTML =
        "🏆 Winner: " + d.name +
        " (" + d.party + ") - Votes: " + d.votes;
});
}

/* LOGOUT */
function logout(){
    window.location.replace("adminLogin.jsp");
}

/* AUTO REFRESH */
setInterval(loadData,5000);
loadData();
</script>

</body>
</html>
