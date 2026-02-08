// ----------------- Auth Functions -----------------

// Register user
function registerUser() {
    const name = document.getElementById('regName').value;
    const email = document.getElementById('regEmail').value;
    const password = document.getElementById('regPassword').value;

    fetch('http://localhost:5000/api/auth/register', {
        method: 'POST',
        headers: { 'Content-Type':'application/json' },
        body: JSON.stringify({ name, email, password })
    })
    .then(res => res.json())
    .then(data => {
        alert(data.message || "Registration successful");
    })
    .catch(err => console.error(err));
}

// Login user
function loginUser() {
    const email = document.getElementById('loginEmail').value;
    const password = document.getElementById('loginPassword').value;

    fetch('http://localhost:5000/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type':'application/json' },
        body: JSON.stringify({ email, password })
    })
    .then(res => res.json())
    .then(data => {
        if(data.token) {
            sessionStorage.setItem('token', data.token);
            sessionStorage.setItem('qrCode', data.qrCode);
            sessionStorage.setItem('name', data.name);
            window.location.href = 'VotingPage.jsp';
        } else {
            alert(data.message);
        }
    })
    .catch(err => console.error(err));
}


// ----------------- Voting Functions -----------------

// Vote for candidate
function vote(candidateId) {
    const token = sessionStorage.getItem('token');
    fetch('http://localhost:5000/api/voter/vote', {
        method: 'POST',
        headers: {
            'Content-Type':'application/json',
            'Authorization':'Bearer ' + token
        },
        body: JSON.stringify({ candidateId })
    })
    .then(res => res.json())
    .then(data => alert(data.message))
    .catch(err => console.error(err));
}

// Load candidates dynamically (for voting page)
function loadCandidates() {
    const token = sessionStorage.getItem('token');
    fetch('http://localhost:5000/api/admin/votes', { 
        headers: { 'Authorization':'Bearer ' + token }
    })
    .then(res => res.json())
    .then(data => {
        const div = document.getElementById('candidates');
        div.innerHTML = '';
        if(data.length === 0) {
            div.innerHTML = `<button onclick="vote(1)">Vote Candidate 1</button>
                             <button onclick="vote(2)">Vote Candidate 2</button>`;
        } else {
            data.forEach(c => {
                div.innerHTML += `<button onclick="vote(${c.id})">Vote ${c.candidate} (${c.party})</button><br>`;
            });
        }
    });
}

// View voting results (admin or user)
function viewResults() {
    const token = sessionStorage.getItem('token');
    fetch('http://localhost:5000/api/admin/votes', { headers: { 'Authorization':'Bearer ' + token }})
    .then(res => res.json())
    .then(data => {
        const div = document.getElementById('results') || document.getElementById('voteResults');
        div.innerHTML = '<h3>Vote Count:</h3>';
        data.forEach(c => {
            div.innerHTML += `${c.candidate} (${c.party}) : ${c.votes_count} votes<br>`;
        });
    });
}


// ----------------- Admin Functions -----------------

// Add candidate
function addCandidate() {
    const token = sessionStorage.getItem('token');
    const name = document.getElementById('candName').value;
    const party = document.getElementById('candParty').value;
    const description = document.getElementById('candDesc').value;

    fetch('http://localhost:5000/api/admin/add', {
        method:'POST',
        headers:{ 'Content-Type':'application/json', 'Authorization':'Bearer ' + token },
        body: JSON.stringify({ name, party, description })
    })
    .then(res=>res.json()).then(data=>alert(data.message))
    .catch(err=>console.error(err));
}

// Remove candidate
function removeCandidate() {
    const token = sessionStorage.getItem('token');
    const id = document.getElementById('candIdRemove').value;

    fetch('http://localhost:5000/api/admin/remove', {
        method:'POST',
        headers:{ 'Content-Type':'application/json', 'Authorization':'Bearer ' + token },
        body: JSON.stringify({ candidateId: id })
    })
    .then(res=>res.json()).then(data=>alert(data.message))
    .catch(err=>console.error(err));
}
