# 🗳️ QR Code Based Online Voting System

## 📌 Project Overview
The **QR Code Based Online Voting System** is a secure web application that allows voters to cast their vote only after QR code authentication.  
Each voter receives a unique QR code during registration, ensuring **one-person-one-vote** and preventing duplicate voting.

---

## 🎯 Objectives
- Secure voter authentication using QR code
- Prevent duplicate voting
- Easy and transparent voting process
- Centralized admin control
- Accurate vote counting and winner declaration

---

## ✨ Features

### 👤 Voter Module
- Voter registration
- Automatic QR code generation
- Login with email and password
- QR code scanning before voting
- Vote only once

### 🛡️ Admin Module
- Admin login
- Add and delete candidates
- View live vote count
- Declare election winner

---

## 🛠️ Technologies Used
- **Frontend:** HTML, CSS, JavaScript, JSP  
- **Backend:** Node.js, Express.js  
- **Database:** MySQL  
- **Library:** html5-qrcode  

---

## ⚙️ How to Run the Project

### 1️⃣ Database Setup
- Create a MySQL database
- Import the file `qr_voting_system.sql`

### 2️⃣ Backend Setup
```bash
npm install
node server.js
