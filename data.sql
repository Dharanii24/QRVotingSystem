CREATE DATABASE QRVotingDB;

USE QRVotingDB;

CREATE TABLE Users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    qr_code TEXT,
    has_voted BOOLEAN DEFAULT FALSE
);

CREATE TABLE Candidates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    party VARCHAR(50),
    description TEXT,
    votes_count INT DEFAULT 0
);

CREATE TABLE Votes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    candidate_id INT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (candidate_id) REFERENCES Candidates(id)
);
