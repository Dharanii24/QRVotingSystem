<!-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
</html> -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QR Voting System - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 15px 20px;
            border-left: 4px solid transparent;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            color: white;
            background: rgba(255, 255, 255, 0.1);
            border-left-color: white;
        }
        .stat-card {
            border-radius: 10px;
            transition: transform 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .chart-container {
            position: relative;
            height: 300px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 d-md-block sidebar collapse">
                <div class="position-sticky pt-3">
                    <div class="text-center mb-4">
                        <h4 class="text-white">
                            <i class="bi bi-shield-lock"></i> Admin Panel
                        </h4>
                        <p class="text-light small" id="adminName">Loading...</p>
                    </div>
                    
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="#" onclick="showSection('dashboard')">
                                <i class="bi bi-speedometer2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#" onclick="showSection('voters')">
                                <i class="bi bi-people"></i> Voter Management
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#" onclick="showSection('candidates')">
                                <i class="bi bi-person-badge"></i> Candidate Management
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#" onclick="showSection('results')">
                                <i class="bi bi-bar-chart"></i> Election Results
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#" onclick="showSection('votes')">
                                <i class="bi bi-clipboard-check"></i> Vote Logs
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#" onclick="showSection('settings')">
                                <i class="bi bi-gear"></i> Settings
                            </a>
                        </li>
                        <li class="nav-item mt-4">
                            <button class="btn btn-danger w-100" onclick="logout()">
                                <i class="bi bi-box-arrow-right"></i> Logout
                            </button>
                        </li>
                    </ul>
                    
                    <div class="mt-5 text-center text-light">
                        <small>QR Voting System v1.0</small>
                        <br>
                        <small id="currentDateTime"></small>
                    </div>
                </div>
            </nav>

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 bg-light">
                <!-- Top Bar -->
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2" id="sectionTitle">Dashboard</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button class="btn btn-sm btn-outline-primary" onclick="refreshData()">
                                <i class="bi bi-arrow-clockwise"></i> Refresh
                            </button>
                            <button class="btn btn-sm btn-outline-success" onclick="exportData()">
                                <i class="bi bi-download"></i> Export
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Dashboard Content -->
                <div id="dashboardSection">
                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="card stat-card bg-primary text-white">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h6 class="card-title">Total Voters</h6>
                                            <h2 id="totalVoters">0</h2>
                                        </div>
                                        <i class="bi bi-people" style="font-size: 3rem; opacity: 0.5;"></i>
                                    </div>
                                    <div class="mt-2">
                                        <small>
                                            <span id="votedCount">0</span> voted • 
                                            <span id="verifiedCount">0</span> verified
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card stat-card bg-success text-white">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h6 class="card-title">Total Votes</h6>
                                            <h2 id="totalVotes">0</h2>
                                        </div>
                                        <i class="bi bi-check-circle" style="font-size: 3rem; opacity: 0.5;"></i>
                                    </div>
                                    <div class="mt-2">
                                        <small id="votePercentage">0% voting completed</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card stat-card bg-warning text-dark">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h6 class="card-title">Candidates</h6>
                                            <h2 id="totalCandidates">0</h2>
                                        </div>
                                        <i class="bi bi-person-badge" style="font-size: 3rem; opacity: 0.5;"></i>
                                    </div>
                                    <div class="mt-2">
                                        <small>Active candidates in election</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card stat-card bg-info text-white">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h6 class="card-title">Live Votes</h6>
                                            <h2 id="liveVotes">0</h2>
                                        </div>
                                        <i class="bi bi-clock-history" style="font-size: 3rem; opacity: 0.5;"></i>
                                    </div>
                                    <div class="mt-2">
                                        <small>Last hour activity</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Charts -->
                    <div class="row mb-4">
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header">
                                    <h6 class="mb-0">Voting Timeline (Last 24 Hours)</h6>
                                </div>
                                <div class="card-body">
                                    <div class="chart-container">
                                        <canvas id="timelineChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header">
                                    <h6 class="mb-0">Voting Status</h6>
                                </div>
                                <div class="card-body">
                                    <div class="chart-container">
                                        <canvas id="statusChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Votes -->
                    <div class="card">
                        <div class="card-header d-flex justify-content-between">
                            <h6 class="mb-0">Recent Votes</h6>
                            <small><a href="#" onclick="showSection('votes')">View All</a></small>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover" id="recentVotesTable">
                                    <thead>
                                        <tr>
                                            <th>Time</th>
                                            <th>Voter</th>
                                            <th>Candidate</th>
                                            <th>Position</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody id="recentVotesBody">
                                        <!-- Recent votes will be loaded here -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Voter Management Section -->
                <div id="votersSection" style="display: none;">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Voter Management</h5>
                            <button class="btn btn-sm btn-primary" onclick="showAddVoterModal()">
                                <i class="bi bi-plus-circle"></i> Add Voter
                            </button>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover" id="votersTable">
                                    <thead>
                                        <tr>
                                            <th>Voter ID</th>
                                            <th>Name</th>
                                            <th>Email</th>
                                            <th>Phone</th>
                                            <th>Status</th>
                                            <th>Voted</th>
                                            <th>Registered</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="votersBody">
                                        <!-- Voters will be loaded here -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Candidate Management Section -->
                <div id="candidatesSection" style="display: none;">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Candidate Management</h5>
                            <button class="btn btn-sm btn-success" onclick="showAddCandidateModal()">
                                <i class="bi bi-plus-circle"></i> Add Candidate
                            </button>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover" id="candidatesTable">
                                    <thead>
                                        <tr>
                                            <th>Photo</th>
                                            <th>Candidate ID</th>
                                            <th>Name</th>
                                            <th>Party</th>
                                            <th>Position</th>
                                            <th>Votes</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="candidatesBody">
                                        <!-- Candidates will be loaded here -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Election Results Section -->
                <div id="resultsSection" style="display: none;">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Election Results</h5>
                        </div>
                        <div class="card-body">
                            <div class="row mb-4">
                                <div class="col-md-8">
                                    <div class="card">
                                        <div class="card-header">
                                            <h6 class="mb-0">Results by Position</h6>
                                        </div>
                                        <div class="card-body">
                                            <div id="resultsContainer">
                                                <!-- Results will be loaded here -->
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="card">
                                        <div class="card-header">
                                            <h6 class="mb-0">Statistics</h6>
                                        </div>
                                        <div class="card-body">
                                            <ul class="list-group list-group-flush">
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>Total Votes Cast</span>
                                                    <strong id="statsTotalVotes">0</strong>
                                                </li>
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>Voting Percentage</span>
                                                    <strong id="statsVotePercentage">0%</strong>
                                                </li>
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>Leading Candidate</span>
                                                    <strong id="statsLeadingCandidate">-</strong>
                                                </li>
                                                <li class="list-group-item d-flex justify-content-between">
                                                    <span>Most Contested Position</span>
                                                    <strong id="statsContestedPosition">-</strong>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Vote Logs Section -->
                <div id="votesSection" style="display: none;">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Vote Logs</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover" id="votesTable">
                                    <thead>
                                        <tr>
                                            <th>Vote ID</th>
                                            <th>Voter ID</th>
                                            <th>Voter Name</th>
                                            <th>Candidate</th>
                                            <th>Position</th>
                                            <th>QR Verified</th>
                                            <th>IP Address</th>
                                            <th>Time</th>
                                        </tr>
                                    </thead>
                                    <tbody id="votesBody">
                                        <!-- Vote logs will be loaded here -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Settings Section -->
                <div id="settingsSection" style="display: none;">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">System Settings</h5>
                        </div>
                        <div class="card-body">
                            <form id="settingsForm">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Election Name</label>
                                            <input type="text" class="form-control" id="electionName" 
                                                   placeholder="Enter election name">
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Start Time</label>
                                            <input type="datetime-local" class="form-control" id="startTime">
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">End Time</label>
                                            <input type="datetime-local" class="form-control" id="endTime">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">System Status</label>
                                            <select class="form-select" id="systemStatus">
                                                <option value="active">Active (Voting Open)</option>
                                                <option value="inactive">Inactive (Voting Closed)</option>
                                                <option value="maintenance">Maintenance Mode</option>
                                            </select>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">QR Code Validity (Minutes)</label>
                                            <input type="number" class="form-control" id="qrValidity" 
                                                   value="5" min="1" max="60">
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Session Timeout (Minutes)</label>
                                            <input type="number" class="form-control" id="sessionTimeout" 
                                                   value="30" min="5" max="120">
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="alert alert-warning">
                                    <h6><i class="bi bi-exclamation-triangle"></i> Important Notes</h6>
                                    <ul class="mb-0">
                                        <li>Changing system status will affect voting access</li>
                                        <li>Election times determine when voting is allowed</li>
                                        <li>QR code validity affects security level</li>
                                        <li>Session timeout affects user experience</li>
                                    </ul>
                                </div>
                                
                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        Save Settings
                                    </button>
                                    <button type="button" class="btn btn-outline-danger" onclick="resetSystem()">
                                        Reset Election Data
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Modals -->
    <!-- Add Candidate Modal -->
    <div class="modal fade" id="addCandidateModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title">Add New Candidate</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form id="addCandidateForm" enctype="multipart/form-data">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Candidate ID *</label>
                                    <input type="text" class="form-control" name="candidate_id" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Full Name *</label>
                                    <input type="text" class="form-control" name="full_name" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Political Party</label>
                                    <input type="text" class="form-control" name="party">
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Position *</label>
                                    <select class="form-select" name="position" required>
                                        <option value="">Select Position</option>
                                        <option value="President">President</option>
                                        <option value="Vice President">Vice President</option>
                                        <option value="Secretary">Secretary</option>
                                        <option value="Treasurer">Treasurer</option>
                                        <option value="Member">Member</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Candidate Photo</label>
                                    <input type="file" class="form-control" name="photo" accept="image/*">
                                    <small class="text-muted">Maximum 5MB. JPG, PNG only.</small>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Biography</label>
                                    <textarea class="form-control" name="bio" rows="6" 
                                              placeholder="Brief biography of the candidate"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">Add Candidate</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="js/ajaxCalls.js"></script>
    <script>
        let adminUser = null;
        let timelineChart = null;
        let statusChart = null;

        // Initialize admin dashboard
        document.addEventListener('DOMContentLoaded', function() {
            checkAdminAuthentication();
            updateDateTime();
            setInterval(updateDateTime, 1000);
            loadDashboardData();
        });

        function checkAdminAuthentication() {
            const token = localStorage.getItem('token');
            adminUser = JSON.parse(localStorage.getItem('user') || '{}');
            
            if (!token || !adminUser.voter_id || adminUser.user_type !== 'admin') {
                window.location.href = 'index.jsp';
                return;
            }
            
            document.getElementById('adminName').textContent = 
                `${adminUser.full_name} (${adminUser.voter_id})`;
        }

        function updateDateTime() {
            const now = new Date();
            document.getElementById('currentDateTime').textContent = 
                now.toLocaleDateString() + ' ' + now.toLocaleTimeString();
        }

        function showSection(sectionId) {
            // Hide all sections
            document.getElementById('dashboardSection').style.display = 'none';
            document.getElementById('votersSection').style.display = 'none';
            document.getElementById('candidatesSection').style.display = 'none';
            document.getElementById('resultsSection').style.display = 'none';
            document.getElementById('votesSection').style.display = 'none';
            document.getElementById('settingsSection').style.display = 'none';
            
            // Remove active class from all nav links
            document.querySelectorAll('.sidebar .nav-link').forEach(link => {
                link.classList.remove('active');
            });
            
            // Show selected section
            document.getElementById(sectionId + 'Section').style.display = 'block';
            
            // Add active class to clicked nav link
            event.target.classList.add('active');
            
            // Update section title
            const titles = {
                'dashboard': 'Dashboard',
                'voters': 'Voter Management',
                'candidates': 'Candidate Management',
                'results': 'Election Results',
                'votes': 'Vote Logs',
                'settings': 'System Settings'
            };
            document.getElementById('sectionTitle').textContent = titles[sectionId];
            
            // Load section data
            if (sectionId === 'voters') {
                loadVoters();
            } else if (sectionId === 'candidates') {
                loadCandidates();
            } else if (sectionId === 'results') {
                loadElectionResults();
            } else if (sectionId === 'votes') {
                loadVoteLogs();
            }
        }

        function loadDashboardData() {
            makeRequest('/api/admin/dashboard-stats', 'GET')
                .then(response => {
                    if (response.success) {
                        // Update stats
                        document.getElementById('totalVoters').textContent = response.stats.total_voters;
                        document.getElementById('votedCount').textContent = response.stats.voted_count;
                        document.getElementById('verifiedCount').textContent = response.stats.verified_count;
                        document.getElementById('totalVotes').textContent = response.stats.total_votes;
                        document.getElementById('totalCandidates').textContent = response.stats.total_candidates;
                        document.getElementById('votePercentage').textContent = response.stats.vote_percentage + '% voting completed';
                        
                        // Calculate live votes (last hour)
                        const hourAgo = new Date(Date.now() - 3600000);
                        const recentVotes = response.recent_votes.filter(vote => 
                            new Date(vote.voted_at) > hourAgo
                        );
                        document.getElementById('liveVotes').textContent = recentVotes.length;
                        
                        // Load recent votes
                        loadRecentVotes(response.recent_votes);
                        
                        // Load charts
                        loadCharts(response);
                    }
                })
                .catch(error => {
                    console.error('Error loading dashboard:', error);
                });
        }

        function loadRecentVotes(votes) {
            const tbody = document.getElementById('recentVotesBody');
            tbody.innerHTML = '';
            
            votes.slice(0, 10).forEach(vote => {
                const row = document.createElement('tr');
                const time = new Date(vote.voted_at).toLocaleTimeString();
                
                row.innerHTML = `
                    <td>${time}</td>
                    <td>${vote.voter_name}</td>
                    <td>${vote.candidate_name}</td>
                    <td>${vote.position}</td>
                    <td>
                        <span class="badge ${vote.qr_verified ? 'bg-success' : 'bg-warning'}">
                            ${vote.qr_verified ? 'Verified' : 'Pending'}
                        </span>
                    </td>
                `;
                tbody.appendChild(row);
            });
        }

        function loadCharts(data) {
            // Destroy existing charts
            if (timelineChart) timelineChart.destroy();
            if (statusChart) statusChart.destroy();
            
            // Timeline Chart
            const timelineCtx = document.getElementById('timelineChart').getContext('2d');
            timelineChart = new Chart(timelineCtx, {
                type: 'line',
                data: {
                    labels: data.statistics.timeline.map(t => t.hour + ':00'),
                    datasets: [{
                        label: 'Votes per Hour',
                        data: data.statistics.timeline.map(t => t.vote_count),
                        borderColor: 'rgb(75, 192, 192)',
                        backgroundColor: 'rgba(75, 192, 192, 0.2)',
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Number of Votes'
                            }
                        },
                        x: {
                            title: {
                                display: true,
                                text: 'Time'
                            }
                        }
                    }
                }
            });
            
            // Status Chart
            const statusCtx = document.getElementById('statusChart').getContext('2d');
            statusChart = new Chart(statusCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Voted', 'Not Voted'],
                    datasets: [{
                        data: [data.stats.voted_count, data.stats.not_voted_count],
                        backgroundColor: [
                            'rgb(54, 162, 235)',
                            'rgb(255, 99, 132)'
                        ],
                        hoverOffset: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        }

        function loadVoters() {
            makeRequest('/api/admin/voters', 'GET')
                .then(response => {
                    if (response.success) {
                        const tbody = document.getElementById('votersBody');
                        tbody.innerHTML = '';
                        
                        response.voters.forEach(voter => {
                            const row = document.createElement('tr');
                            const regDate = new Date(voter.created_at).toLocaleDateString();
                            
                            row.innerHTML = `
                                <td>${voter.voter_id}</td>
                                <td>${voter.full_name}</td>
                                <td>${voter.email}</td>
                                <td>${voter.phone || '-'}</td>
                                <td>
                                    <span class="badge ${voter.is_verified ? 'bg-success' : 'bg-warning'}">
                                        ${voter.is_verified ? 'Verified' : 'Not Verified'}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge ${voter.has_voted ? 'bg-success' : 'bg-secondary'}">
                                        ${voter.has_voted ? 'Voted' : 'Not Voted'}
                                    </span>
                                </td>
                                <td>${regDate}</td>
                                <td>
                                    <div class="btn-group btn-group-sm">
                                        ${!voter.is_verified ? `
                                            <button class="btn btn-outline-success" 
                                                    onclick="verifyVoter('${voter.voter_id}')">
                                                <i class="bi bi-check-circle"></i> Verify
                                            </button>
                                        ` : ''}
                                        <button class="btn btn-outline-info" 
                                                onclick="viewVoterDetails('${voter.voter_id}')">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </div>
                                </td>
                            `;
                            tbody.appendChild(row);
                        });
                    }
                })
                .catch(error => {
                    console.error('Error loading voters:', error);
                });
        }

        function verifyVoter(voter_id) {
            makeRequest(`/api/admin/voters/verify/${voter_id}`, 'PUT')
                .then(response => {
                    if (response.success) {
                        Swal.fire('Success', 'Voter verified successfully!', 'success');
                        loadVoters();
                    }
                })
                .catch(error => {
                    Swal.fire('Error', 'Failed to verify voter', 'error');
                });
        }

        function loadCandidates() {
            makeRequest('/api/voter/candidates', 'GET')
                .then(response => {
                    if (response.success) {
                        const tbody = document.getElementById('candidatesBody');
                        tbody.innerHTML = '';
                        
                        response.candidates.forEach(candidate => {
                            const row = document.createElement('tr');
                            
                            row.innerHTML = `
                                <td>
                                    <img src="${candidate.photo_path || 'https://via.placeholder.com/40'}" 
                                         alt="${candidate.full_name}" 
                                         class="rounded-circle" width="40" height="40">
                                </td>
                                <td>${candidate.candidate_id}</td>
                                <td>${candidate.full_name}</td>
                                <td>${candidate.party || 'Independent'}</td>
                                <td>${candidate.position}</td>
                                <td>
                                    <span class="badge bg-primary">${candidate.vote_count} votes</span>
                                </td>
                                <td>
                                    <span class="badge ${candidate.is_active ? 'bg-success' : 'bg-secondary'}">
                                        ${candidate.is_active ? 'Active' : 'Inactive'}
                                    </span>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-warning" 
                                                onclick="editCandidate('${candidate.candidate_id}')">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button class="btn btn-outline-danger" 
                                                onclick="deleteCandidate('${candidate.candidate_id}')">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            `;
                            tbody.appendChild(row);
                        });
                    }
                })
                .catch(error => {
                    console.error('Error loading candidates:', error);
                });
        }

        function showAddCandidateModal() {
            document.getElementById('addCandidateForm').reset();
            const modal = new bootstrap.Modal(document.getElementById('addCandidateModal'));
            modal.show();
        }

        document.getElementById('addCandidateForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            
            makeRequest('/api/admin/candidates', 'POST', formData, true)
                .then(response => {
                    if (response.success) {
                        Swal.fire('Success', 'Candidate added successfully!', 'success');
                        bootstrap.Modal.getInstance(document.getElementById('addCandidateModal')).hide();
                        loadCandidates();
                    }
                })
                .catch(error => {
                    Swal.fire('Error', 'Failed to add candidate', 'error');
                });
        });

        function deleteCandidate(candidate_id) {
            Swal.fire({
                title: 'Delete Candidate',
                text: 'Are you sure you want to delete this candidate? This action cannot be undone.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, delete it',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    makeRequest(`/api/admin/candidates/${candidate_id}`, 'DELETE')
                        .then(response => {
                            if (response.success) {
                                Swal.fire('Success', 'Candidate deleted successfully!', 'success');
                                loadCandidates();
                            }
                        })
                        .catch(error => {
                            Swal.fire('Error', 'Failed to delete candidate', 'error');
                        });
                }
            });
        }

        function loadElectionResults() {
            makeRequest('/api/admin/results', 'GET')
                .then(response => {
                    if (response.success) {
                        const container = document.getElementById('resultsContainer');
                        container.innerHTML = '';
                        
                        // Group results by position
                        const positions = {};
                        response.results.forEach(result => {
                            if (!positions[result.position]) {
                                positions[result.position] = [];
                            }
                            positions[result.position].push(result);
                        });
                        
                        // Render each position
                        for (const [position, candidates] of Object.entries(positions)) {
                            const positionDiv = document.createElement('div');
                            positionDiv.className = 'mb-4';
                            
                            let tableHtml = `
                                <h6 class="mb-3">${position}</h6>
                                <table class="table table-sm">
                                    <thead>
                                        <tr>
                                            <th>Rank</th>
                                            <th>Candidate</th>
                                            <th>Party</th>
                                            <th>Votes</th>
                                            <th>Percentage</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                            `;
                            
                            const totalVotes = candidates.reduce((sum, c) => sum + c.vote_count, 0);
                            
                            candidates.forEach(candidate => {
                                const percentage = totalVotes > 0 ? 
                                    ((candidate.vote_count / totalVotes) * 100).toFixed(1) : 0;
                                
                                tableHtml += `
                                    <tr ${candidate.rank === 1 ? 'class="table-success"' : ''}>
                                        <td>
                                            <span class="badge ${candidate.rank === 1 ? 'bg-warning' : 'bg-secondary'}">
                                                ${candidate.rank}
                                            </span>
                                        </td>
                                        <td>${candidate.full_name}</td>
                                        <td>${candidate.party || 'Independent'}</td>
                                        <td>${candidate.vote_count}</td>
                                        <td>${percentage}%</td>
                                    </tr>
                                `;
                            });
                            
                            tableHtml += '</tbody></table>';
                            positionDiv.innerHTML = tableHtml;
                            container.appendChild(positionDiv);
                        }
                        
                        // Update statistics
                        document.getElementById('statsTotalVotes').textContent = response.statistics.total_votes || 0;
                        
                        const votePercentage = response.statistics.voting_stats.total_voters > 0 ?
                            ((response.statistics.voting_stats.voted_count / response.statistics.voting_stats.total_voters) * 100).toFixed(1) : 0;
                        document.getElementById('statsVotePercentage').textContent = votePercentage + '%';
                        
                        // Find leading candidate
                        let leadingCandidate = null;
                        response.results.forEach(candidate => {
                            if (candidate.rank === 1) {
                                leadingCandidate = candidate;
                            }
                        });
                        
                        if (leadingCandidate) {
                            document.getElementById('statsLeadingCandidate').textContent = 
                                `${leadingCandidate.full_name} (${leadingCandidate.vote_count} votes)`;
                        }
                        
                        // Find most contested position
                        const positionCounts = {};
                        response.results.forEach(candidate => {
                            positionCounts[candidate.position] = (positionCounts[candidate.position] || 0) + 1;
                        });
                        
                        let mostContestedPosition = '';
                        let maxCandidates = 0;
                        for (const [position, count] of Object.entries(positionCounts)) {
                            if (count > maxCandidates) {
                                mostContestedPosition = position;
                                maxCandidates = count;
                            }
                        }
                        
                        document.getElementById('statsContestedPosition').textContent = 
                            `${mostContestedPosition} (${maxCandidates} candidates)`;
                    }
                })
                .catch(error => {
                    console.error('Error loading results:', error);
                });
        }

        function loadVoteLogs() {
            makeRequest('/api/admin/results', 'GET')
                .then(response => {
                    if (response.success) {
                        const tbody = document.getElementById('votesBody');
                        tbody.innerHTML = '';
                        
                        response.vote_logs.forEach(vote => {
                            const row = document.createElement('tr');
                            const time = new Date(vote.voted_at).toLocaleString();
                            
                            row.innerHTML = `
                                <td><small class="text-muted">${vote.vote_id}</small></td>
                                <td>${vote.voter_id}</td>
                                <td>${vote.voter_name}</td>
                                <td>${vote.candidate_name}</td>
                                <td>${vote.position}</td>
                                <td>
                                    <span class="badge ${vote.qr_verified ? 'bg-success' : 'bg-warning'}">
                                        ${vote.qr_verified ? 'Yes' : 'No'}
                                    </span>
                                </td>
                                <td><small>${vote.ip_address || 'N/A'}</small></td>
                                <td><small>${time}</small></td>
                            `;
                            tbody.appendChild(row);
                        });
                    }
                })
                .catch(error => {
                    console.error('Error loading vote logs:', error);
                });
        }

        function refreshData() {
            const currentSection = document.querySelector('[style*="display: block"]').id.replace('Section', '');
            
            if (currentSection === 'dashboard') {
                loadDashboardData();
            } else if (currentSection === 'voters') {
                loadVoters();
            } else if (currentSection === 'candidates') {
                loadCandidates();
            } else if (currentSection === 'results') {
                loadElectionResults();
            } else if (currentSection === 'votes') {
                loadVoteLogs();
            }
            
            Swal.fire('Success', 'Data refreshed successfully!', 'success');
        }

        function exportData() {
            const currentSection = document.querySelector('[style*="display: block"]').id.replace('Section', '');
            
            let exportContent = '';
            let filename = '';
            
            if (currentSection === 'voters') {
                exportContent = 'Voter ID,Name,Email,Phone,Status,Voted,Registered\n';
                document.querySelectorAll('#votersBody tr').forEach(row => {
                    const cells = row.querySelectorAll('td');
                    if (cells.length >= 7) {
                        exportContent += `"${cells[0].textContent}","${cells[1].textContent}","${cells[2].textContent}","${cells[3].textContent}","${cells[4].textContent}","${cells[5].textContent}","${cells[6].textContent}"\n`;
                    }
                });
                filename = 'voters.csv';
            } else if (currentSection === 'results') {
                exportContent = 'Position,Rank,Candidate,Party,Votes,Percentage\n';
                makeRequest('/api/admin/results', 'GET')
                    .then(response => {
                        if (response.success) {
                            response.results.forEach(candidate => {
                                const percentage = candidate.total_votes > 0 ? 
                                    ((candidate.vote_count / candidate.total_votes) * 100).toFixed(1) : 0;
                                exportContent += `"${candidate.position}","${candidate.rank}","${candidate.full_name}","${candidate.party || 'Independent'}","${candidate.vote_count}","${percentage}%"\n`;
                            });
                            downloadCSV(exportContent, 'election_results.csv');
                        }
                    });
                return;
            }
            
            downloadCSV(exportContent, filename);
        }

        function downloadCSV(content, filename) {
            const blob = new Blob([content], { type: 'text/csv;charset=utf-8;' });
            const link = document.createElement('a');
            const url = URL.createObjectURL(blob);
            
            link.setAttribute('href', url);
            link.setAttribute('download', filename);
            link.style.visibility = 'hidden';
            
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }

        function resetSystem() {
            Swal.fire({
                title: 'Reset Election Data',
                html: `
                    <p class="text-danger"><strong>WARNING: This action cannot be undone!</strong></p>
                    <p>This will:</p>
                    <ul class="text-start">
                        <li>Delete all votes</li>
                        <li>Reset candidate vote counts to zero</li>
                        <li>Mark all voters as "not voted"</li>
                        <li>Preserve voter and candidate data</li>
                    </ul>
                    <p>Type <strong>RESET</strong> to confirm:</p>
                    <input type="text" id="resetConfirm" class="form-control" placeholder="Type RESET here">
                `,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Reset System',
                confirmButtonColor: '#dc3545',
                preConfirm: () => {
                    const confirmText = document.getElementById('resetConfirm').value;
                    if (confirmText !== 'RESET') {
                        Swal.showValidationMessage('Please type RESET to confirm');
                        return false;
                    }
                    return true;
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire({
                        title: 'Resetting...',
                        text: 'Please wait while we reset the system.',
                        allowOutsideClick: false,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    });
                    
                    // Simulate reset process
                    setTimeout(() => {
                        Swal.fire('Success', 'System reset completed successfully!', 'success');
                        loadDashboardData();
                    }, 2000);
                }
            });
        }

        function logout() {
            Swal.fire({
                title: 'Logout',
                text: 'Are you sure you want to logout?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Yes, logout'
            }).then((result) => {
                if (result.isConfirmed) {
                    localStorage.removeItem('token');
                    localStorage.removeItem('user');
                    window.location.href = 'index.jsp';
                }
            });
        }
    </script>
</body>
</html>